FROM node:10.0.0
# Secret variable as env 
ENV SECRET_WORD = TwelveFactor

# Create app directory
WORKDIR /app

#Copy folder to app

COPY . /app
RUN npm install

EXPOSE 3000
CMD [ "npm","start" ]