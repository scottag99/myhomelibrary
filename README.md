# My Home Library
Connecting aspiring readers with donors to build a home library of books.

## Development Environment setup

My Home Library is a Ruby on Rails application deployed to a Heroku pipeline. Rails 5, Ruby 2.3.0, and Postgres 9.4(?) are the current framework versions.

### How to use vagrant to deploy My Home Library for development

First you need to have vagrant installed locally:

    https://www.vagrantup.com/downloads.html

Currently, only VirtualBox is configured for deployment. Vagrant can deploy to VMWare Fusion but the plugin requires a separate license so you need VirtualBox:

    https://www.virtualbox.org/wiki/Downloads

##### Application

The current Vagrantfile for the My Home Library app will setup an ubuntu VM that is similar to the Heroku stack that the application will run on

Vagrant will also setup port forwards for 3000 to local 3000 for access to remote app server

##### Deploy

The first time you deploy with Vagrant, an OS image is downloaded and provisioned. Future deploys will only update the application code.

1. Open terminal in same directory of this repo
1. Execute `vagrant up`. This will download the pre-configured linux VM for VirtualBox and run some initialization scripts.
1. In a browser, navigate to http://127.0.0.1:3000/ and the My Home Library splash page should render.
1. You are now ready to code. To execute new migrations, gems, or restart the server, run `vagrant reload`.

##### Helpful commands:

* `vagrant up` to start the environment.
* `vagrant ssh` to open up a terminal to the server
* `vagrant reload` to run `bundler`, `db:migrate`, and restart the rails server

## Application Flow and Structure

### Process Flow

1. Member of Barbara Bush Houston Literacy Foundation (BBHLF) logs in to Admin area.
1. BBHLF user creates a new organization. This will almost always be a school right now but could expand beyond schools in the future.
1. A user is assigned as a "Partner" to the organization. This will be a librarian or teacher in most cases.
1. A new campaign is created for the organization with title like "Fall 2016".
1. The partner assigned above is now able to log in the Partner area.
1. The partner works with kids to build their wish list by searching the catalog of books and assigning to the kid's specific wish list.
1. After the wish lists are created, donors can search for lists by school, gender, grade, or teacher. They will not see the child's name.
1. The donor can choose to fund a wish list which will take them to the donation page where the amount for the wish list is pre-populated in the form.
1. Upon successful submission of the form, the transaction reference is recorded and the wish list is marked as "funded"

### Authentication

Authentication is handled by Auth0. Metadata on the Auth0 record marks users as Admin or Partner. Before filters on the different area controllers handle verifying access to these areas.

### Payment Form

The donations will be processed by Kimbia. An embeddable form has been created by them to use in the My Home Library application. Four global javascript variables should be set to populate the form. They are:

|Field|Purpose|JS Variable Example
|---|---|---
|Semester|Campaign Name|`var Semester = "Fall 2016";`
|School|Organization Name|`var SchoolName = "Browning Elementary";`
|Wishlist ID|ID of wish list selected by donor|`var WishlistID = "34";`
|Donation|Amount of wish list. Donor can change|`var DonationLevel = 100.00;`

## Running Rails Commands

You can SSH to the Vagrant box if you don't have Rails setup on your local machine and run rails commands from the `/vagrant` directory.
