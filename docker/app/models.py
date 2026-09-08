from database import db

class Ticket(db.Model):

    __tablename__ = "tickets"

    id = db.Column(db.Integer, primary_key=True)

    title = db.Column(db.String(200))

    description = db.Column(db.Text)

    status = db.Column(db.String(50))

    priority = db.Column(db.String(50))

    owner = db.Column(db.String(100))