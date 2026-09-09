import os

from flask import Flask
from flask import jsonify
from flask import request
from flask import Response

from prometheus_client import Counter
from prometheus_client import generate_latest
from prometheus_client import CONTENT_TYPE_LATEST

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

db.init_app(app)

REQUESTS = Counter(
    "ticket_requests_total",
    "Total Requests"
)

with app.app_context():
    db.create_all()


@app.route("/health")
def health():
    return {"status": "UP"}


@app.route("/metrics")
def metrics():
    return Response(
        generate_latest(),
        mimetype=CONTENT_TYPE_LATEST
    )


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
            "owner": t.owner
        }
        for t in tickets
    ])


@app.route("/tickets", methods=["POST"])
def create_ticket():

    data = request.json

    ticket = Ticket(
        title=data["title"],
        description=data["description"],
        status="OPEN",
        priority=data["priority"],
        owner="unassigned"
    )

    db.session.add(ticket)
    db.session.commit()

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
        "owner": ticket.owner
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

    db.session.commit()

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


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )