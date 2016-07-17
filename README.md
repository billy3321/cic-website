## 國會調查兵團網站

這是[國會調查兵團](https://cic.tw)的網站原始碼，以MIT釋出。

API文件請見：

https://g0v.hackpad.com/API-bSmx3h922jc

[![Build Status](https://travis-ci.org/billy3321/cic-website.svg?branch=master)](https://travis-ci.org/billy3321/cic-website)

## Project Build

- Make sure you have already start PostgreSql and Redis

```
bundle install
```

```
cp config/database.yml.default config/database.yml
cp config/config.yml.default config/config.yml
```

- Setup database.yml, start postgresql and start redis-server.

```
bundle install
rake db:create db:migrate
rails server
```

- Yo login as admin, setup Google or Facebook OAuth login at `config/config.yml`, and set the user as admin in rails console.

## Redis

- install

```
brew install redis-server
```

## PostgreSql

- install

```
brew install postgresql
brew unlink postgresql
brew link postgresql
ARCHFLAGS="-arch x86_64" gem install pg
```

- goto http://postgresapp.com/ download and start it.

- setup user & password

```
psql
```

- replace your_name & your_password

```
CREATE USER your_name WITH PASSWORD 'your_password';
CREATE DATABASE "your_name";
GRANT ALL PRIVILEGES ON DATABASE "your_name" to "your_name";
ALTER USER "your_name" WITH SUPERUSER;
```

## LICENSE
This project is release under MIT License.

