from flask import Flask, render_template, url_for, redirect, flash, send_from_directory
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, TextAreaField, EmailField
from wtforms.validators import DataRequired, InputRequired
import os
import smtplib


import logging

app = Flask(__name__)
handler = logging.FileHandler('./app.log')  # errors logged to this file
handler.setLevel(logging.ERROR)  # only log errors and above
app.logger.addHandler(handler)  # attach the handler to the app's logger

app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
EMAIL_IVAN_RAVIC = "ravic.ivan88@gmail.com"
app.config['DEBUG'] = True
app.config['TESTING'] = False
app.config['MAIL_SERVER'] = "smtp.gmail.com"
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TTL'] = True
app.config['MAIL_USE_SSL'] = False
# app.config['MAIL_DEBUG'] = True
app.config['MAIL_USERNAME'] = os.getenv('MAIL_USERNAME')
app.config['MAIL_PASSWORD'] = os.getenv('MAIL_PASSWORD')
app.config['MAIL_DEFAULT_SENDER'] = os.getenv('MAIL_USERNAME')
app.config['MAIL_MAX_EMAILS'] = None
# app.config['MAIL_SUPRESS_SEND'] = False
app.config['MAIL_ASCII_ATTACHMENT'] = False

# FORM FOR MESSAGE
class Client_Message(FlaskForm):
  client_name = StringField("Name", validators = [InputRequired()])
  client_email = EmailField("Email Address", validators = [InputRequired()])
  client_message = TextAreaField("Message", validators = [InputRequired()])
  send = SubmitField("Get In Touch")

@app.route("/", methods=["POST", "GET"])
def home():

  message_client_form = Client_Message()

  if message_client_form.validate_on_submit():
        with smtplib.SMTP(app.config['MAIL_SERVER'], port=app.config['MAIL_PORT']) as connection:
          connection.starttls()
          connection.login(user=app.config['MAIL_USERNAME'], password=app.config['MAIL_PASSWORD'])
          connection.sendmail(from_addr=app.config['MAIL_USERNAME'], to_addrs=f"{EMAIL_IVAN_RAVIC}",
                              msg=f"Subject:{message_client_form.client_name.data}\n\n{message_client_form.client_message.data}\n\nClient email address: {message_client_form.client_email.data}")
          flash("Message is send. Thanks.")
        return redirect(url_for("home", _anchor='contact'))
        
  return render_template("index.html", message_client_form=message_client_form)

@app.route("/gaginislatkisi", methods=["POST", "GET"])
def gaginislatkisi():
  return render_template("project_1_describe.html")

@app.route("/follower_checker", methods=["POST", "GET"])
def follower_checker():
  return render_template("project_2_describe.html")

@app.route("/e-commerce", methods=["POST", "GET"])
def e_commerce():
  return render_template("e-commerce_project.html")

@app.route("/resume_pdf")
def resume_pdf():
  return send_from_directory(".", "Ivan's Resume.pdf")
  


if __name__ == "__main__":
  app.run(debug=True)