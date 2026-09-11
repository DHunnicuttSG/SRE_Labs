import os

from flask import Flask
from flask import jsonify
from flask import request
from flask import Response
from flask import render_template

from prometheus_client import Counter
from prometheus_client import generate_latest
from prometheus_client import CONTENT_TYPE_LATEST
from prometheus_client import Gauge

from datetime import datetime

from database import db
from models import Ticket, Comment, AssignmentHistory, StatusHistory

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = (
    f"postgresql://labuser:labpassword@postgres:5432/ticketdb"
)

VALID_TRANSITIONS = {
    "OPEN": ["IN_PROGRESS"],
    "IN_PROGRESS": ["RESOLVED"],
    "RESOLVED": ["CLOSED"],
    "CLOSED": []
}

SLA_RULES = {
    "SEV1": 30,
    "SEV2": 120,
    "SEV3": 480,
    "SEV4": 1440
}

db.init_app(app)

REQUESTS = Counter(
    "ticket_requests_total",
    "Total Requests"
)

open_tickets = Gauge(
    "ticket_open_total",
    "Total open tickets"
)

sev1_tickets = Gauge(
    "ticket_sev1_total",
    "Total SEV1 tickets"
)

sla_breaches = Gauge(
    "ticket_sla_breached_total",
    "Total SLA breaches"
)

# Metric Refresh function
def update_metrics():

    open_tickets.set(
        Ticket.query.filter(
            Ticket.status != "CLOSED"
        ).count()
    )

    sev1_tickets.set(
        Ticket.query.filter_by(
            severity="SEV1"
        ).count()
    )

    sla_breaches.set(
        Ticket.query.filter_by(
            sla_breached=True
        ).count()
    )


with app.app_context():
    db.create_all()
    update_metrics()


@app.route("/health")
def health():
    return {"status": "UP"}


@app.route("/metrics")
def metrics():
    update_metrics()
    return Response(
        generate_latest(),
        mimetype=CONTENT_TYPE_LATEST
    )

# Dashboard page
@app.route("/")
def home():

    return render_template(
        "index.html"
    )

@app.route("/ticket/<int:id>")
def ticket_page(id):

    return render_template(
        "ticket.html",
        ticket_id=id
    )

@app.route("/create-ticket")
def create_ticket_page():

    return render_template(
        "create_ticket.html"
    )

@app.route("/dashboard")
def dashboard():

    return render_template(
        "dashboard.html"
    )

@app.route("/ticket/<int:id>/history")
def history_page(id):

    return render_template(
        "history.html",
        ticket_id=id
    )

@app.route("/ticket/<int:id>/sla")
def sla_page(id):

    return render_template(
        "sla.html",
        ticket_id=id
    )

@app.route("/open-incidents")
def open_incidents():

    return render_template(
        "open_incidents.html"
    )

@app.route("/sev1-incidents")
def sev1_incidents():

    return render_template(
        "sev1_incidents.html"
    )



# routes that return json
@app.route("/tickets", methods=["GET"])
def get_tickets():

    REQUESTS.inc()

    tickets = Ticket.query.all()

    return jsonify([
        {
            "id": t.id,
            "title": t.title,
            "status": t.status,
            "priority": t.priority,
            "owner": t.owner,
            "severity": t.severity
        }
        for t in tickets
    ])


@app.route("/tickets", methods=["POST"])
def create_ticket():

    data = request.json

    severity = data.get(
        "severity", "SEV4"
    )

    ticket = Ticket(
        title=data["title"],
        description=data["description"],
        status="OPEN",
        priority=data["priority"],
        owner="unassigned",
        severity=severity,
        sla_target_minutes=SLA_RULES[severity]
    )

    db.session.add(ticket)
    
    db.session.commit()

    update_metrics()
    
    return {"message": "created"}

@app.route("/tickets/<int:id>", methods=["GET"])
def get_ticket(id):

    ticket = Ticket.query.get_or_404(id)

    return {
        "id": ticket.id,
        "title": ticket.title,
        "description": ticket.description,
        "status": ticket.status,
        "priority": ticket.priority,
        "severity": ticket.severity,
        "owner": ticket.owner,
        "created_at": ticket.created_at,
        "acknowledged_at": ticket.acknowledged_at,
        "resolved_at": ticket.resolved_at,
        "sla_target_minutes": ticket.sla_target_minutes,
        "sla_breached": ticket.sla_breached
    }

@app.route("/tickets/<int:id>", methods=["PUT"])
def update_ticket(id):

    ticket = Ticket.query.get_or_404(id)

    data = request.json

    #
    # Owner changes
    #

    new_owner = data.get("owner")

    if new_owner and new_owner != ticket.owner:

        assignment = AssignmentHistory(
            ticket_id=ticket.id,
            old_owner=ticket.owner,
            new_owner=new_owner
        )

        db.session.add(assignment)

        ticket.owner = new_owner

    #
    # Status changes
    #

    new_status = data.get("status")

    if new_status and new_status != ticket.status:

        allowed = VALID_TRANSITIONS.get(
            ticket.status,
            []
        )

        if new_status not in allowed:

            return {
                "error":
                f"Invalid transition "
                f"{ticket.status} -> {new_status}"
            }, 400

        history = StatusHistory(
            ticket_id=ticket.id,
            old_status=ticket.status,
            new_status=new_status
        )

        db.session.add(history)

        ticket.status = new_status

        if new_status == "RESOLVED":
            ticket.resolved_at = datetime.timezone.utc()

    #
    # General updates
    #

    ticket.title = data.get(
        "title",
        ticket.title
    )

    ticket.description = data.get(
        "description",
        ticket.description
    )

    ticket.priority = data.get(
        "priority",
        ticket.priority
    )

    evaluate_sla(ticket)
    
    db.session.commit()

    update_metrics()

    return {
        "message": "ticket updated"
    }

@app.route("/tickets/<int:id>", methods=["DELETE"])
def delete_ticket(id):

    ticket = Ticket.query.get_or_404(id)

    db.session.delete(ticket)

    db.session.commit()

    return {
        "message": "ticket deleted"
    }

@app.route("/tickets/<int:id>/comments", methods=["GET"])
def get_comments(id):

    Ticket.query.get_or_404(id)

    comments = Comment.query.filter_by(
        ticket_id=id
    ).all()

    return jsonify([
        {
            "id": c.id,
            "author": c.author,
            "comment": c.comment,
            "created_at": c.created_at
        }
        for c in comments
    ])

@app.route("/tickets/<int:id>/comments", methods=["POST"])
def create_comment(id):

    Ticket.query.get_or_404(id)

    data = request.json

    comment = Comment(
        ticket_id=id,
        author=data["author"],
        comment=data["comment"]
    )

    db.session.add(comment)
    db.session.commit()

    return {
        "message": "comment added"
    }

@app.route("/tickets/<int:id>/assignments", methods=["GET"])
def get_assignment_history(id):

    rows = AssignmentHistory.query.filter_by(
        ticket_id=id
    ).all()

    return jsonify([
        {
            "old_owner": r.old_owner,
            "new_owner": r.new_owner,
            "changed_at": r.changed_at
        }
        for r in rows
    ])

@app.route("/tickets/<int:id>/status-history", methods=["GET"])
def get_status_history(id):

    rows = StatusHistory.query.filter_by(
        ticket_id=id
    ).all()

    return jsonify([
        {
            "old_status": r.old_status,
            "new_status": r.new_status,
            "changed_at": r.changed_at
        }
        for r in rows
    ])

@app.route("/tickets/<int:id>/acknowledge", methods=["POST"])
def acknowledge_ticket(id):

    ticket = Ticket.query.get_or_404(id)

    ticket.acknowledged_at = datetime.utcnow()

    db.session.commit()

    return {
        "message": "ticket acknowledged"
    }


# SLA evaluation function
def evaluate_sla(ticket):

    if not ticket.resolved_at:
        return

    duration = (
        ticket.resolved_at -
        ticket.created_at
    )

    minutes = duration.total_seconds() / 60

    if minutes > ticket.sla_target_minutes:

        ticket.sla_breached = True


@app.route("/tickets/<int:id>/sla", methods=["GET"])
def get_sla(id):

    ticket = Ticket.query.get_or_404(id)

    return {

        "severity": ticket.severity,

        "target_minutes":
            ticket.sla_target_minutes,

        "created_at":
            ticket.created_at,

        "acknowledged_at":
            ticket.acknowledged_at,

        "resolved_at":
            ticket.resolved_at,

        "breached":
            ticket.sla_breached
    }


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )