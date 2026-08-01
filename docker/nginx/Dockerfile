FROM node:20-alpine AS frontend
WORKDIR /build
COPY frontend/package.json frontend/package-lock.json* ./
RUN npm install
COPY frontend/ ./
RUN npm run build

FROM nginx:1.25-alpine

COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY www/ /var/www/noon/
RUN rm -rf /var/www/noon/app /var/www/noon/admin
COPY --from=frontend /build/dist /var/www/noon/app/
COPY --from=frontend /build/dist-admin /var/www/noon/admin/
