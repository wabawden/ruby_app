# Ruby webserver log parser

This parser receives a log as argument

<code>parser.rb webserver.log</code>

and returns:

1. a list of webpages with most page views ordered from most pages views to less page views.
2. a list of webpages with most unique page views also ordered.

## Additional functionality

In addition to the above requirements, there are command-line options to display the following:

1. a list of IP addresses ordered by most page views to least.
2. a list of IP addresses ordered by most unique page views to least.
3. a list of entry nodes (pages viewed first for each user) sorted by most users to least. This could be further refined using timestamp data in a more detailed log.
4. a list of exit nodes (pages viewed last for each user) sorted by most users to least. This could be further refined using timestamp data in a more detailed log.

## Classes

### Log

The parser creates an instance of the Log class containing all the data from the given arguments (more than one log file can be passed to the parser and the data will be combined), as well as a record of the source files. Additional functionality and reporting can easily be provided by adding methods to this class.

### PageView

The parser also creates an instance of the PageView class for each line of the log. In this way the script can easily be adapted to more detailed logs, by, for example, initializing this class with a timestamp attribute.

## Error Handling

The script raises exceptions with bespoke messages in the event of no file being provided, the file not being found, the file not being a .log, containing invalid page routes or invalid IP addresses.

## Testing

The script was continually tested using RSpec. Initially, various file errors were tested to help produce appropriate error handling functionality. Tests were then written for each Log method against a short test file.

## Thank You

Thank you for viewing my submission. I am looking forward to having the opportunity to discuss it later: in particular, I am interested in discussing how to avoid duplicating code in the sort_by_views and sort_by_user Log methods, and how to assimilate the error handling within the Log and PageView classes.