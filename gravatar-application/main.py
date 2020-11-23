import libgravatar
from flask import Flask
import logging

app = Flask(__name__)
app.config['DEBUG'] = True

@app.route('/avatar/<email>',  methods=['GET'])
def get_avatar(email):
    '''
    Gets profile image url from Gravatar 
    Return:
        image(str): image url wrapped in IMG tag
    '''
    g = libgravatar.Gravatar(email)
    image_url = g.get_image()
    image = f'<img src="{image_url}" />'
    #simple logging
    logging.info(f'{email} avatar url {image}')
    return image

@app.route('/health',  methods=['GET'])
def health_check():
    return "healthy"


def main():
    app.run(host='0.0.0.0')
if __name__ == "__main__":
    main()