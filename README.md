
# Yaknowboutblogmusic


This application was generated with the [rails_apps_composer](https://github.com/RailsApps/rails_apps_composer) gem
provided by the [RailsApps Project](http://railsapps.github.io/).

## Installing

First of all, you need install Ruby on your machine (skip this if you
already have)

## Installing Ruby

If you have Macosx or Linux, go to terminal

```
  $ \curl -sSL https://get.rvm.io | bash -s stable --rails
```

and wait a little.
I will update for Windows installation latter.

## Installing yaknowboutblogmusic locally:

```
   $ git clone https://github.com/jahpd/yaknowboutblogmusic
   $ cd yaknowboutblogmusic
   $ bundle install
```

### Migration and seed database

In first running, database (SQLite 3.0) must be seed first, to include some posts
examples:

```
  $ rake --tasks
  $ rake db:migrate
  $ rake db:seed
```
  
## Running

```
  $ rails s 
```

This will start a server on 127.0.0.1:3000
If you want to start in another port:

```
  $ rails s - p 3001
```

# Diagnostics

Acessing a webpage like
[this](http://localhost:3000/posts/1/hear?c=5d000080001f00000000000000000508f7f014ae2e34fad792f976127ce795bd535d17482c64acba78844ca0082ba0)
for first time, both ace and termlib fails in load contents. If you
refresh page (Ctrl+R or F5), ace and termlib works properly.

If the application doesn’t work as expected, please [report an issue](https://github.com/RailsApps/rails_apps_composer/issues)
and include these diagnostics:

We’d also like to know if you’ve found combinations of recipes or
preferences that do work together.

Recipes:

* controllers
* core
* deployment
* email
* extras
* frontend
* gems
* git
* init
* learn_rails
* models
* prelaunch
* rails_bootstrap
* rails_devise
* rails_devise_pundit
* rails_foundation
* rails_omniauth
* rails_signup_download
* railsapps
* readme
* routes
* saas
* setup
* testing
* tests4
* views

Preferences:

* git: true
* apps4: rails-devise
* authentication: devise
* authorization: false
* better_errors: true
* deployment: none
* local_env_file: false
* pry: false
* quiet_assets: true
* starter_app: false
* dev_webserver: thin
* prod_webserver: thin
* database: sqlite
* templates: erb
* tests: none
* frontend: bootstrap3
* email: gmail
* devise_modules: default
* form_builder: simple_form
* rvmrc: false
* ban_spiders: true

### Database

This application uses SQLite with ActiveRecord.

### Development

-   Template Engine: ERB
-   Testing Framework: Test::Unit
-   Front-end Framework: Bootstrap 3.0 (Sass)
-   Form Builder: SimpleForm
-   Authentication: Devise
-   Authorization: None
-   Admin: None

### Email

Email delivering isnt enabled yet. I must study...

The application is configured to send email using a Gmail account.

Email delivery is disabled in development.


### Documentation and Support

This is the only documentation.

But Documentation about Gibberish audio machine can be found [here](http://www.charlie-roberts.com/gibberish/),
to help coders.


### Similar Projects

 - [gibberish.js](https://github.com/charlieroberts/Gibberish) (the audio library used)
 - [gibberish live coding environment](http://gibber.mat.ucsb.edu/)
 - [vivace live coding environment](http://void.cc/freakcoding/)
 - [coffee-collider](https://github.com/mohayonao/CoffeeCollider)

I suggest you read this [paper](http://www.mat.ucsb.edu/Publications/WebBrowser-as-Synth-Interface.pdf)

### Contributing

If you make improvements to this application, please share with others.

-   Fork the project on GitHub.
-   Make your feature addition or bug fix.
-   Commit with Git.
-   Send the author a pull request.

If you add functionality to this application, create an alternative
implementation, or build an application that is similar, please contact
me and I’ll add a note to the README so that others can find your work.

### Credits

- jahpd

### License

creative commons 3.0 cc-by-sa
