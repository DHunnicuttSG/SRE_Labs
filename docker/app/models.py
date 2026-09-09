from database import db

class Ticket(db.Model):

    __tablename__ = "tickets"

    id = db.Column(db.Integer, primary_key=True)

    title = db.Column(db.String(200))
    description = db.Column(db.Text)

    status = db.Column(db.String(50))
    priority = db.Column(db.String(50))

    owner = db.Column(db.String(100))


class Comment(db.Model):

    __tablename__ = "comments"

    id = db.Column(db.Integer, primary_key=True)

    ticket_id = db.Column(
        db.Integer,
        db.ForeignKey("tickets.id"),
        nullable=False
    )

    author = db.Column(
        db.String(100),
        nullable=False
    )

    comment = db.Column(
        db.Text,
        nullable=False
    )

    created_at = db.Column(
        db.DateTime,
        server_default=db.func.now()
    )

class AssignmentHistory(db.Model):

    __tablename__ = "assignment_history"

    id = db.Column(db.Integer, primary_key=True)

    ticket_id = db.Column(
        db.Integer,
        db.ForeignKey("tickets.id"),
        nullable=False
    )

    old_owner = db.Column(db.String(100))

    new_owner = db.Column(
        db.String(100),
        nullable=False
    )

    changed_at = db.Column(
        db.DateTime,
        server_default=db.func.now()
    )

class StatusHistory(db.Model):

    __tablename__ = "status_history"

    id = db.Column(db.Integer, primary_key=True)

    ticket_id = db.Column(
        db.Integer,
        db.ForeignKey("tickets.id"),
        nullable=False
    )

    old_status = db.Column(db.String(50))

    new_status = db.Column(
        db.String(50),
        nullable=False
    )

    changed_at = db.Column(
        db.DateTime,
        server_default=db.func.now()
    )    