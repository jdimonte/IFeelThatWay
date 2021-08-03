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
* User can post prompts
* User can comment on prompts
* User can react on commments
* User can tap prompt to see other comments
* User can reply to other comments

**Optional Nice-to-have Stories**

* User can create polls
* User can comment on polls
* User can answer polls
* User can view top comments
* User can view top replies
* User can search for specific topics
* User can save comments and replies
* User can view their profile and change their profile picture 
* User can share comments to their instagram story
* User can make requests
* User can sign in with their google account
* User can sort prompts by most popular 

### 2. Screen Archetypes

* Login Screen
   * User can login
   * Redirect to Create Account Screen
* Create Account Screen
   * User can create a new account
   * Redirect to Login Screen
* Top Feelings Screen
   * User can view top comments and replies by other users
* Topics Screen
   * User can view, follow, and search for various topics
* Following Screen
   * User can view prompts for topics they are following and sort prompts based on popularity or most recent
* Saved Screen
   * User can save comments and replies and share them to their instagram story

* Topic Screen
   * User can view a topic and a feed of prompts and polls related to the topic along with a featured comment for each prompt/poll
* Prompt Screen
   * User can view the prompt and the prompt's comments
* Poll Screen
   * User can view the poll and the poll's comments
* Comment Screen
   * User can view the comment and the comment's replies

* Profile Screen
   * User can change their profile picture
* Request Screen
   * User can make requests

* Create Prompt Screen
   * User can create a prompt in a given topic
* Create Poll Screen
   * User can create a poll in a given topic, and say whether or not they want the poll to offer multiple selection

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Top Feelings
* Topics
* Following
* Saved

**Flow Navigation** (Screen to Screen)

* Login Screen
   * Home, Accessable from Profile (logout)
* Create Account Screen
   * Accessable from Login

* Topics Screen
   * Topics
* Topic Screen
   * Accessable from Topics Screen
* Prompt Screen
   * Accessable from Topic Screen or Following Screen
* Poll Screen
   * Accessable from Topic Screen or Following Screen
* Comment Screen
   * Accessable from Prompt Screen or Poll Screen

* Saved Screen
   * Saved
* Top Feelings Screen
   * Top Feelings
* Following Screen
   * Following

* Profile Screen
    * Accessable from Top Feelings, Topics, Following, or Saved
* Request Screen
    * Accessable from Top Feelings, Topics, Following, or Saved

* Create Prompt Screen
    * Accessable from Topic Screen
* Create Poll Screen
    * Accessable from Topic Screen

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

Topic
| Property  | Type     | Description |
| --------  | -------- | --------    |
| objectId  | String | unique id for the user post (default field) |
| category | String | category of the topic |
| followersArray | Array of user IDs | users who are following this topic |
| createdAt | DateTime | date when topic is created (default field) |

Prompt
| Property  | Type     | Description |
| --------  | -------- | --------    |
| objectId  | String | unique id for the user post (default field) |
| topic | String | category prompt is in |
| question | String | question by admin |
| hasComments | bool | if the prompt has any comments |
| commentsCount | Number | number of comments |
| createdAt | DateTime | date when prompt is created (default field) |

Poll
| Property  | Type     | Description |
| --------  | -------- | --------    |
| objectId  | String | unique id for the user poll (default field) |
| topic | String | category poll is in |
| question | String | question by admin |
| firstAnswer| String | first answer to poll |
| secondAnswer| String | second answer to poll |
| thirdAnswer| String | third answer to poll |
| fourthAnswer| String | fourth answer to poll |
| firstArray| Array of users | users who have voted for the first answer |
| secondArray| Array of users | users who have voted for the second answer |
| thirdArray| Array of users | users who have voted for the third answer |
| fourthArray| Array of users | users who have voted for the fourth answer |
| firstPlace| Number | which option has the most votes |
| secondPlace| Number | which option has the second most votes |
| thirdPlace| Number | which option has the second least votes |
| fourthPlace| Number | which option has the least votes |
| multipleSelection| bool | if users can vote for multiple options |
| numberOfOptions| Number | how many options the poll has |
| createdAt | DateTime | date when poll is created (default field) |

Comment
| Property  | Type     | Description |
| --------  | -------- | --------    |
| objectId | String | unique id for the comment (default field) |
| user  | User Pointer | pointer to the user who commented |
| post  | Prompt Pointer | pointer to the post the comment is for |
| poll  | Poll Pointer | pointer to the poll the comment is for |
| text | String | comment text |
| agreeCount | Number | number of people who have agreed with (liked) the question |
| agreeArray | Array of user IDs | users who are agree with this comment |
| savedArray | Array of user IDs | users who have saved this comment |
| createdAt | DateTime | date when comment is created (default field) |

Replies
| Property  | Type     | Description |
| --------  | -------- | --------    |
| objectId | String | unique id for the reply (default field) |
| user  | User Pointer | pointer to the user who replied |
| comment  | Comment Pointer | pointer to the comment the reply is for |
| text | String | comment text |
| agreeCount | Number | number of people who have agreed with (liked) the question |
| agreeArray | Array of user IDs | users who are agree with this reply |
| savedArray | Array of user IDs | users who have saved this reply |
| createdAt | DateTime | date when reply is created (default field) |

Request
| Property  | Type     | Description |
| --------  | -------- | --------    |
| objectId | String | unique id for the reply (default field) |
| request  | String | request from the user |
| createdAt | DateTime | date when request is created (default field) |

Report
| Property  | Type     | Description |
| --------  | -------- | --------    |
| objectId | String | unique id for the reply (default field) |
| message | String | what the comment / reply says |
| messageAuthor  | User Pointer | the user who created the comment / reply |
| commentId  | Comment Pointer | the comment that is being reported |
| replyID | Reply Pointer | the reply that is being reported |
| createdAt | DateTime | date when report is created (default field) |


### Networking
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

### Extra
* Saved Screen
   * (READ) User's saved. Grabs all of the saved comments from the User with query.

* Top Feelings Screen
   * (READ) Comments by number of interactions. Sorts the comments by the top 10 for number of people who have positively interacted with it.

* Profile Screen
    * (READ) User information. Grabs their profile color.
    * (Update) User information. Changes their profile color.

### [Optional] APIs Requests

Facebook Instagram API to share feelings to your instragram story.
Google Auth API to login with your google account.

### Colors

8A81B1 //Light purple
DEF8F5 //Light blue
5C6199 //Dark blue
020202 //Black
E58B98 //pink
