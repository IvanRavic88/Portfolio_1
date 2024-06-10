from flask import Flask, url_for, redirect, flash, render_template_string
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, TextAreaField, EmailField
from wtforms.validators import InputRequired
from flask_wtf.csrf import CSRFProtect
import smtplib
import aws_lambda_wsgi
import boto3



app = Flask(__name__)


s3 = boto3.client("s3")
ssm = boto3.client("ssm")

def get_secret(secret_name):
    response = ssm.get_parameter(Name=secret_name, WithDecryption=True)
    return response["Parameter"]["Value"]

app.config['SECRET_KEY'] = get_secret("/portfolio/secret_key")
csrf = CSRFProtect(app)

EMAIL_IVAN_RAVIC = "ravic.ivan88@gmail.com"
app.config['DEBUG'] = True
app.config['TESTING'] = False
app.config['MAIL_SERVER'] = "smtp.gmail.com"
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TTL'] = True
app.config['MAIL_USE_SSL'] = False
app.config['MAIL_USERNAME'] = get_secret('/portfolio/mail_username')
app.config['MAIL_PASSWORD'] = get_secret('/portfolio/mail_password')
app.config['MAIL_DEFAULT_SENDER'] = get_secret('/portfolio/mail_username')
app.config['MAIL_MAX_EMAILS'] = None
app.config['MAIL_ASCII_ATTACHMENT'] = False

# FORM FOR MESSAGE
class Client_Message(FlaskForm):
    client_name = StringField("Name", validators=[InputRequired()])
    client_email = EmailField("Email Address", validators=[InputRequired()])
    client_message = TextAreaField("Message", validators=[InputRequired()])
    honeypot =StringField("Leave this  empty")
    send = SubmitField("Get In Touch")
    
@app.route("/", methods=["POST", "GET"])
def home():
    bucket_name = "ivan-ravic-website-dev"
    key = "index.html"
    file_object = s3.get_object(Bucket=bucket_name, Key=key)
    file_content = file_object["Body"].read().decode("utf-8")

    message_client_form = Client_Message()

    if message_client_form.validate_on_submit():
        if message_client_form.honeypot.data:
            return render_template_string(file_content)
        
        with smtplib.SMTP(app.config['MAIL_SERVER'], port=app.config['MAIL_PORT']) as connection:
            connection.starttls()
            connection.login(user=app.config['MAIL_USERNAME'], password=app.config['MAIL_PASSWORD'])
            connection.sendmail(
                from_addr=app.config['MAIL_USERNAME'],
                to_addrs=EMAIL_IVAN_RAVIC,
                msg=f"Subject:{message_client_form.client_name.data}\n\n{message_client_form.client_message.data}\n\nClient email address: {message_client_form.client_email.data}"
            )
            flash("Message is sent. Thanks.")
        
        return render_template_string(file_content, _anchor="contact")

   

    return render_template_string(file_content, message_client_form=message_client_form)



# if __name__ == "__main__":
#     app.run(debug=True)
def lambda_handler(event, context):
    return aws_lambda_wsgi.response(app, event, context)


