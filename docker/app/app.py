import os

from flask import Flask
from flask import jsonify
from flask import request
from flask import Response

from prometheus_client import Counter
from prometheus_client import generate_latest
from prometheus_client import CONTENT_TYPE_LATEST

from database import db
from models import Ticket

app = Flask(__name__)

app.config["SQLALCHEMY_DATABASE_URI"] = (
    f"postgresql://labuser:labpassword@postgres:5432/ticketdb"
)

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


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000
    )