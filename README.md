Original App Design Project - README Template
===

# I feel that way

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Anonymous forums for women discussing common problems and solutions. An environment for advice from other individuals on issues related to your period, your relationship, or anything you are struggling with. This is a space to get relief about your feelings, knowing you are not alone.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Mental Wellbeing and Social
- **Mobile:** There is reacting and commenting, which is perfect for a mobile environment.
- **Story:** Targets individuals who have new or uncomfortable feelings and want to see if there are others who feel the same way. They are also seeking advice on these issues or being relieved that these feelings are normal.
- **Market:** It is targeted for women, so the market is more than half of the population. It is welcome to anyone who is interested in reading the answers and  advice for these issues.
- **Habit:** It will be more popular if new content is regularly posted, and as long as users have questions. It could also be easy to read in the morning or at night, just wondering the various prompts and comments.
- **Scope:** Doable, based on what we will learn in this course, the time for working on the app, and the support for research the new features.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can create a new account
* User can login / logout
* User can view prompts
* User can comment on prompts
* User can react on prompts
* User can react on comments
* User can post their own feelings
* User can comment on prompts

**Optional Nice-to-have Stories**

* User can react to polls
* User can create polls
* User can view top feelings
* User can view top advice
* User can tap prompt to see other comments
* User can reply to other comments
* User can search for specific topics within topics
* User can see notifications when someone reacts to their post, replies to their comment, or comments on their post
* User can save posts
* User can view their profile 
* User can view other profiles and see their favorite posts

### 2. Screen Archetypes

* Welcome Screen
   * Redirect to Login Screen
   * Redirect to Create Account Screen
* Login Screen
   * User can login
* Create Account Screen
   * User can create a new account
* Topics Screen
   * User can login
* Prompts Screen
   * User can view a feed of prompts
* Prompt Screen
   * User can view prompt and comments
#### Extra
* Saved Screen
   * User can save prompts
* Top Feelings Screen
   * User can view top thoughts by other users
* Profile Screen
   * User can profiles

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home
* Topics
* Top Feelings
* Saved

**Flow Navigation** (Screen to Screen)

* Welcome Screen
   * If you logout
* Login Screen
   * Home
* Create Account Screen
   * Home
* Topics Screen
   * Topics
* Prompts Screen
   * Topics
* Prompt Screen
   * Topics
#### Extra
* Saved Screen
   * Saved
* Top Feelings Screen
   * Top Feelings
* Profile Screen
    * Home

## Wireframes
<img src="https://github.com/jdimonte/IFeelThatWay/blob/main/wireframe.jpeg" width=600>

### [BONUS] Digital Wireframes & Mockups
<img src="https://github.com/jdimonte/IFeelThatWay/blob/main/digitalwireframe.png" width=600>

### [BONUS] Interactive Prototype
<img src="https://github.com/jdimonte/IFeelThatWay/blob/main/walkthrough.gif" width=250>

## Schema 
### Models
User
| Property  | Type     | Description |
| --------  | -------- | --------    |
| objectId | String | unique id for the user (default field) |
| username | String | user's username |
| password | String (hidden) | user's password |
| email | String | user's email |
| profilePicture | Color | color of the user's profile picture |
| topicsFollowing | Array of Topics | all of the topcis a user is following |
| savedFeelings | Array of Strings | all of the comments the user has saved |

Topic
| Property  | Type     | Description |
| --------  | -------- | --------    |
| objectId  | String | unique id for the user post (default field) |
| category | String | category of the topic |
| Prompts | Array of Prompts | all of the prompts within the topic |
| createdAt | DateTime | date when post is created (default field) |

Prompt
| Property  | Type     | Description |
| --------  | -------- | --------    |
| objectId  | String | unique id for the user post (default field) |
| topic | String | category prompt is in |
| question | String | question by admin |
| agreeCount| Number | number of people who have liked the question  |
| comments| Array of Comments | all of the comments on the prompt  |
| createdAt | DateTime | date when post is created (default field) |

Poll
| Property  | Type     | Description |
| --------  | -------- | --------    |
| objectId  | String | unique id for the user poll (default field) |
| topic | String | category prompt is in |
| question | String | question by admin |
| agreeCount| Number | number of people who have liked the question |
| firstAnswer| String | first answer to poll |
| secondAnswer| String | second answer to poll |
| thirdAnswer| String | third answer to poll |
| firstCount| Number | number of users who have selected the first answer |
| secondCount| Number | number of users who have selected the second answer |
| thirdCount| Number | number of users who have selected the third answer |
| interactionCount | Number | number of users who have answered the poll |
| comments| Array of Comments | all of the comments on the poll  |
| createdAt | DateTime | date when post is created (default field) |

Comment/Replies
| Property  | Type     | Description |
| --------  | -------- | --------    |
| objectId | String | unique id for the comment (default field) |
| text | String | comment text |
| agreeCount | Number | number of people who have agreed with (liked) the question |


### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
* Login Screen
   * (READ) User information. Takes in username and password and knows which user is signed in.
<img width="769" alt="login" src="https://user-images.githubusercontent.com/67511953/125112063-8d4b3100-e09b-11eb-801e-dbe85a455c5a.png">
* Create Account Screen
   * (CREATE) User. Sets the user's username, password, and email information.
<img width="767" alt="newuser" src="https://user-images.githubusercontent.com/67511953/125112034-7f95ab80-e09b-11eb-9f1a-74e5711bc477.png">
* Topics Screen
   * (READ) Topics. Grabs all of the topics from the Query. Set each topic in a table view, that leads to the specific prompts screen.
<img width="653" alt="gettingtopics" src="https://user-images.githubusercontent.com/67511953/125112110-9936f300-e09b-11eb-9eff-03e1a3372cff.png">
* Prompts Screen
   * (READ) Prompts. Grabs all of the prompts from within a specific topic from the query.
<img width="615" alt="gettingprompts" src="https://user-images.githubusercontent.com/67511953/125112105-976d2f80-e09b-11eb-9036-fef0e184e01b.png">
* Prompt Screen
   * (READ) Comments. Grabs all of the comments from a specific prompt from the query.
#### Extra
* Saved Screen
   * (READ) User's saved. Grabs all of the saved comments from the User with query.
* Top Feelings Screen
   * (READ) Comments by number of interactions. Sorts the comments by the top 10 for number of people who have positively interacted with it.
* Profile Screen
    * (READ) User information. Grabs their profile color.
    * (Update) User information. Changes their profile color.
