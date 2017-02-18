# Parsetagram for iOS

**Parsetagram** is a photo sharing app using Parse as its backend. Like, comment, and share.

By: **Pedro Sandoval Segura**


## Video Walkthrough

A quick video walkthrough can be found here: https://youtu.be/K72qJxXyiVY

## Screenshots

![Prog](http://i.imgur.com/HapLbhJ.png)

## User Stories - Upgrades
- Tapping on a post's username or profile photo goes to that user's profile page
- User should have the ability to share pictures

## User Stories - Current Functionality
- User can sign up to create a new account using Parse authentication
- User can log in and log out of his or her account
- The current signed in user is persisted across app restarts
- User can take a photo, add a caption, and post it to "Instagram"
- User can view the last 20 posts submitted to "Instagram"
- User can pull to refresh the last 20 posts submitted to "Instagram"
- User can load more posts once he or she reaches the bottom of the feed using infinite Scrolling
- User can tap a post to view post details, including timestamp and creation
- User can use a tab bar to switch between all "Instagram" posts and posts published only by the user.
- Shows the username and creation time for each post
- After the user submits a new post, show a progress HUD while the post is being uploaded to Parse.
- UIAlertController notifies users of invalid passwords, taken usernames, etc.
- User Profiles:
   - Allow the logged in user to add a profile photo
   - Display the profile photo with each post
   - Tapping on a post's username or profile photo goes to that user's profile page
- User can comment on a post and see all comments for each post in the post details screen.
- User can like a post and see number of likes for each post in the post details screen.
- Run your app on your phone and use the camera to take the photo
- UIAlertController notifies users of invalid passwords, taken usernames, etc.
- Refresh control displays last updated timestamp on post table views
- Comment messages are timestamped down to the second, minute, hour, and day
- Custom home screen app icon

## Credits

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [MBProgressHUD](https://github.com/jdg/MBProgressHUD) - activity indicator

## License

    Copyright 2016 Pedro Sandoval Segura

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
