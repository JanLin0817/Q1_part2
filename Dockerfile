FROM nginx:1.27-alpine
COPY index.html page2.html page3.html /usr/share/nginx/html/
EXPOSE 80
