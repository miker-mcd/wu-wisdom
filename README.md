# wu-wisdom

## Description
wu-wisdom is a place where visitors can receive a Witty and Unpredictable piece of wisdom by clicking on a member of the rap group, the Wu-Tang Clan. A random lyric line is displayed the [musixmatch](https://www.musixmatch.com/) API.

## Technologies Used
- Back End: Sinatra, Active Record, PostgreSQL
- Front End: Ruby, HTML
- APIs: musixmatch

## Using wu-wisdom
Getting wisdom is easy! Simply click on a member of the Wu-Tang Clan and a random lyric line is generated from one of the member's songs.

## Intall wu-wisdom locally
1. Ensure the latest version of Sinatra is installed
2. Fork the GearShare repository to your GitHub account
3. Clone the repository in your account to your computer
4. Acquire and place the following in an env file located in the root folder:
musixmatch API key

## Challenges
The main challenge I faced was building the logic to interact with the musixmatch API. Based on the data provided by specific responses, I had to structure a series of requests and parsed responses that ultimately led to one lyric line. Each response was a complicated data structure that I had to parse and use for the next request.

## Next Steps
The top priority is to style the entire application. My idea was to display the lyric similar to how famous quotes are posted on Facebook or Instagram in a minimal font type on a modern card.

The next priority is to minimize the feedback loop to fetch a lyric line. One solution would be to persist a large quantity of lyric lines into a database for each member so that the application relies on database queries rather than requests to another API.

Other fun features include a lyrics guessing game, auto-tweeting and allowing for posting to social media accounts.