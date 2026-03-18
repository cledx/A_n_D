<img src="app/assets/images/logo.png" alt="logo" width="120">

[Play A&D](https://a-n-d-6c853770e414.herokuapp.com/)

A fun, decision-based role-playing game, where you can create your own character and story or leave it up to AI to take you on a journey.

<img width="1503" height="801" alt="image" src="https://github.com/user-attachments/assets/fc8077af-b874-459c-8576-0d715684edce" />
<br>

## Getting Started
### Setup

Install gems
```
bundle install
```

### ENV Variables
Create `.env` file
```
touch .env
```
Inside `.env`, set these variables. For any APIs, see group Slack channel.
```
CLOUDINARY_URL=your_own_cloudinary_url_key
```

### DB Setup
```
rails db:create
rails db:migrate
rails db:seed
```

### Run a server
```
rails s
```

## Built With
- [Rails 7](https://guides.rubyonrails.org/) - Backend / Front-end
- [Stimulus JS](https://stimulus.hotwired.dev/) - Front-end JS
- [Heroku](https://heroku.com/) - Deployment
- [PostgreSQL](https://www.postgresql.org/) - Database
- [Bootstrap](https://getbootstrap.com/) — Styling
- [Figma](https://www.figma.com) — Prototyping

## Team Members
- [Carlos Ledoux](https://www.linkedin.com/in/carlos-ledoux/)
- [Koji Juan Kaga](https://www.linkedin.com/in/koji-juan-kaga-53a65823b/)
- [Glaucia Grossi](https://www.linkedin.com/in/glau-grossi/)
- [Katherine Rush](https://www.linkedin.com/in/katherine-rush-070448392/)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is private and maintained by the A&D team. All rights reserved.
