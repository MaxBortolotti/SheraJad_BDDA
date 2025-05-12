from flask import Flask, request, render_template
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

app = Flask(__name__, template_folder='../templates', static_folder='../static')

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:Amaziane47@localhost/sherajad'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# --- MODELS ---

class Category(db.Model):
    __tablename__ = 'category'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)

class Mechanic(db.Model):
    __tablename__ = 'mechanic'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)

class Rating(db.Model):
    __tablename__ = 'rating'
    id = db.Column(db.Integer, primary_key=True)
    average = db.Column(db.Float)
    bayesaverage = db.Column(db.Float)  
    usersrated = db.Column(db.Integer)
    games = db.relationship('Game', backref='rating', lazy=True)
    reviews = db.relationship('Review', backref='rating', lazy=True)

class Person(db.Model):
    __tablename__ = 'person'
    id = db.Column(db.Integer, primary_key=True)
    firstname = db.Column(db.String(50))
    lastname = db.Column(db.String(50))
    user = db.relationship('User', backref='person', uselist=False)
    reviews = db.relationship('Review', backref='person', lazy=True)

class Review(db.Model):
    __tablename__ = 'review'
    id = db.Column(db.Integer, primary_key=True)
    userrating = db.Column(db.Float)
    message = db.Column(db.String(255))
    idRa = db.Column(db.Integer, db.ForeignKey('rating.id'), nullable=False)
    idP = db.Column(db.Integer, db.ForeignKey('person.id'), nullable=False)

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(50), unique=True)
    password = db.Column(db.String(255))
    creationdate = db.Column(db.DateTime, default=datetime.utcnow)
    idP = db.Column(db.Integer, db.ForeignKey('person.id'), unique=True, nullable=False)

class Game(db.Model):
    __tablename__ = 'game'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)
    description = db.Column(db.String(1024))
    yearpublished = db.Column(db.Integer)
    minplayers = db.Column(db.Integer)
    maxplayers = db.Column(db.Integer)
    playingtime = db.Column(db.Integer)
    minplaytime = db.Column(db.Integer)
    maxplaytime = db.Column(db.Integer)
    minage = db.Column(db.Integer)
    owned = db.Column(db.Integer)
    trading = db.Column(db.Integer)
    wanting = db.Column(db.Integer)
    wishing = db.Column(db.Integer)
    idRa = db.Column(db.Integer, db.ForeignKey('rating.id'), unique=True, nullable=False)

    categories = db.relationship('Category', secondary='conngc', backref=db.backref('games', lazy='dynamic'))
    mechanics = db.relationship('Mechanic', secondary='conngm', backref=db.backref('games', lazy='dynamic'))
    ratings = db.relationship('Rating', backref='game', lazy=True)


class ConnGC(db.Model):
    __tablename__ = 'conngc'
    idG = db.Column(db.Integer, db.ForeignKey('game.id'), primary_key=True)
    idC = db.Column(db.Integer, db.ForeignKey('category.id'), primary_key=True)

class ConnGM(db.Model):
    __tablename__ = 'conngm'
    idG = db.Column(db.Integer, db.ForeignKey('game.id'), primary_key=True)
    idM = db.Column(db.Integer, db.ForeignKey('mechanic.id'), primary_key=True)

class ConnGP(db.Model):
    __tablename__ = 'conngp'
    idG = db.Column(db.Integer, db.ForeignKey('game.id'), primary_key=True)
    idP = db.Column(db.Integer, db.ForeignKey('person.id'), primary_key=True)



# --- ROUTES ---

@app.route('/')
def home():
    Rgames = Game.query.order_by(Game.wishing.desc()).limit(6).all()
    return render_template('home.html', message="Bienvenue sur notre site de jeux!", games=Rgames)

@app.route('/search-games', methods=['GET'])
def get_games():
    sort_by = request.args.get('sort_by')
    lastname = request.args.get('lastname')
    games = []
    message = None

    try:
        if lastname:
            people = Person.query.filter(Person.lastname.ilike(f"%{lastname}%")).all()
            if people:
                person_ids = [p.id for p in people]
                games = db.session.query(Game).join(ConnGP).filter(ConnGP.idP.in_(person_ids)).all()
                if not games:
                    message = "Aucun jeu trouvé pour ce nom de famille."
            else:
                message = "Aucune personne trouvée avec ce nom de famille."
        else:
            # Si aucune recherche par nom, alors on trie
            if sort_by == 'name':
                games = Game.query.order_by(Game.name).all()
            elif sort_by == 'yearpublished':
                games = Game.query.order_by(Game.yearpublished).all()
            elif sort_by == 'average':
                games = Game.query.join(Rating).order_by(Rating.average.desc()).all()
            elif sort_by == 'minplayers':
                games = Game.query.order_by(Game.minplayers).all()
            else:
                games = Game.query.all()
    except Exception as e:
        message = "Une erreur est survenue lors de la recherche."

    return render_template('search-games.html', games=games, sort_by=sort_by, lastname=lastname, message=message)

@app.route('/auth')
def auth_func():
    return render_template('auth.html')

@app.route('/game/<int:game_id>')
def game_detail(game_id):
    game = Game.query.get_or_404(game_id)
    return render_template('game-detail.html', game=game)



# --- MAIN ---

if __name__ == '__main__':
    app.run(debug=True)
