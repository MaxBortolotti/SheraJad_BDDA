from flask import Flask, request, render_template, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import text

from datetime import datetime
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user


app = Flask(__name__, template_folder='../templates', static_folder='../static')

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:root@localhost/sherajad'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.secret_key = 'super secret key'
app.config['SESSION_TYPE'] = 'filesystem'
#sess.init_app(app)
db = SQLAlchemy(app)


#config flask_login
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'
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
    admin = db.Column(db.Boolean, default=False)
    idP = db.Column(db.Integer, db.ForeignKey('person.id'), unique=True, nullable=False)

    def get_id(self):
        return str(self.id)

    @property
    def is_active(self):
        return True
    
    @property
    def is_authenticated(self):
        return True
    


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
    Rgames = (db.session.query(Game).from_statement(text("CALL get_top_games(:cnt)")).params(cnt=6).all())
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
    reviews = Review.query.join(Rating).filter(Rating.id == game.idRa).all()
    creators = Person.query.join(ConnGP).filter(ConnGP.idG == game_id).all()
    return render_template('game-detail.html', game=game, reviews=reviews, creators=creators)

@app.route('/ajout-avis', methods=['POST'])
def ajoutavis():
    game_id = request.form['game_id']
    note = request.form['note']
    description = request.form['description']

    game = Game.query.get(game_id)
    current_person = Person.query.filter_by(id=current_user.idP).first()

    rating_id = game.idRa
    new_review = Review(userrating=note, message=description, idRa=rating_id , idP=current_person.id)
    db.session.add(new_review)
    db.session.commit()
    flash('Avis Ajouté !')
    return redirect(url_for('game_detail', game_id=game_id))


@app.route('/auth', methods=['GET', 'POST'])
def auth():
    if request.method == 'POST':
        # Logique de connexion
        email = request.form['email']
        password = request.form['password']
        result = db.session.execute(text('SELECT * FROM users WHERE email = "'+email+'" AND password COLLATE utf8mb4_general_ci  = sha2(concat(creationdate, "'+password+'"), 224) COLLATE utf8mb4_general_ci'))
        authIsValid = result.one_or_none() is not None


        if authIsValid:
            # Récupérer l'utilisateur de la base de données
            user = User.query.filter_by(email=email).first()
            if user:
                login_user(user)
                flash('Connexion réussie !')
            else:
                flash('Utilisateur non trouvé.')
        else:
            flash('Identifiants invalides.')
        return redirect(url_for('home'))
    return render_template('auth.html')

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id)) 


@app.route('/logout')
#@login_required
def logout():
    logout_user()
    return redirect(url_for('home'))



@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        prenom = request.form['prenom']
        nom = request.form['nom']
        email = request.form['email']
        password = request.form['password']

        # Vérifiez si l'email existe déjà
        if User.query.filter_by(email=email).first():
            flash('Cette adresse e-mail est déjà utilisée.')
            return render_template('register.html')

        new_person = Person(lastname=nom, firstname=prenom)
        db.session.add(new_person)
        db.session.commit()
        person = Person.query.filter_by(lastname=nom, firstname=prenom).first()
        # Récupérer l'ID de la nouvelle personne
        person_id = int(person.id)

        query = f"INSERT INTO users (email, password, idP, creationdate) VALUES ('{email}', SHA2(CONCAT(NOW(), '{password}'), 224), {person_id}, NOW())"
        result = db.session.execute(text(query))
        db.session.commit()
    

        flash('Inscription réussie ! Vous pouvez maintenant vous connecter.')
        return redirect(url_for('auth'))
    return render_template('register.html')

#ADMIN DASHBORD
@app.route('/dashboard_admin')
@login_required
def dashboard_admin():
    # Vérifiez si l'utilisateur actuel est un admin
    if not current_user.admin:
        flash('Accès non autorisé.')
        return redirect(url_for('home'))
    
    users = User.query.all()
    reviews = Review.query.all()

    return render_template('dashboard_admin.html', users=users, reviews=reviews)

@app.route('/admin/create-user', methods=['POST'])
@login_required
def create_user():
    if not current_user.admin:
        flash('Accès non autorisé.')
        return redirect(url_for('home'))

    prenom = request.form['prenom']
    nom = request.form['nom']
    email = request.form['email']
    password = request.form['password']

    # Vérifie si un utilisateur avec cet email existe déjà
    if User.query.filter_by(email=email).first():
        flash('Email déjà utilisé.')
        return redirect(url_for('dashboard_admin'))

    # Création de la personne
    new_person = Person(lastname=nom, firstname=prenom)
    db.session.add(new_person)
    db.session.commit()
    person = Person.query.filter_by(lastname=nom, firstname=prenom).first()
    person_id = person.id

    # Insertion dans la table users avec password haché dynamiquement
    query = text("""
        INSERT INTO users (email, password, idP, creationdate)
        VALUES (:email, SHA2(CONCAT(NOW(), :password), 224), :idP, NOW())
    """)
    db.session.execute(query, {
        'email': email,
        'password': password,
        'idP': person_id
    })
    db.session.commit()

    flash('Utilisateur créé avec succès.')
    return redirect(url_for('dashboard_admin'))

@app.route('/admin/delete-user/<int:user_id>', methods=['POST'])
@login_required
def delete_user(user_id):
    if not current_user.admin:
        flash('Accès non autorisé.')
        return redirect(url_for('home'))

    user = User.query.get_or_404(user_id)
    db.session.delete(user)
    db.session.commit()
    flash('Utilisateur supprimé avec succès.')
    return redirect(url_for('dashboard_admin'))

@app.route('/admin/delete-review/<int:review_id>', methods=['POST'])
@login_required
def delete_review(review_id):
    if not current_user.admin:
        flash('Accès non autorisé.')
        return redirect(url_for('home'))

    review = Review.query.get_or_404(review_id)
    db.session.delete(review)
    db.session.commit()
    flash('Avis supprimé avec succès.')
    return redirect(url_for('dashboard_admin'))



# --- MAIN ---

if __name__ == '__main__':
    app.run(debug=True)
