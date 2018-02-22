 # What was Project? Http Server Project built with the Pragmatic Studio Course

 1. Main function is Handler.ex - This hands ALL incomming requests the sever and is where the MAIN pipeline exists
 2. RAW Http requests were used to build the server originally but it can now handle actual browser requests.
 3. Supervisor Tree can be seen with :oberser.start() GUI

# What Elixir Concepts did you learn? These ones stick out.

 1. GenServers - See FourOhFourCounter, PledgeServer, SensorServer, and KickStarer
 2. Supervisors - See Supervisor, KickStarter, and ServicesSupervisor
 3. Testing - See any Test Files
 4. Parsing a JSON file - Parser.ex
 5. Inner works of a GenServer - See Pledge_Server_Hand_Rolled.ex
 6. Regex - Plugins.ex
 7. Transposing Erlang Code - http_client, http_server
 8. Rendering Embeded Elixir - view.ex
 9. Structs - conv.ex
 10. Supervising NON-OTP Module - KickStarer.ex
 11. Accessing Files - Wildthings.ex, 
 12. Parsing Markdown - PagesController.ex
 13. Responding with templates - PagesController and File Handler

# Major Coding Take Aways

1. Write Stub Code When Starting out. You don't need to flush out entire application on the first go.
2. Write down functionality of Module Step-by-Step in English before coding it
3. Don't worry about refactoring UNTIL your module is WORKING AS INTENTED
4. When refactoring, be on the lookout for GENERIC code. Refactor these into separate functions/modules.
Try to be as vauge as possible with the intended functionality as this will increase usability. 

# How did you find was the best way to learn from the video course?

1. Watch them code, Pause Video, then code yourself. 
Do NOT try to keep up with them without pausing the video.
This results in not absorbing the teachings and just copying their code.
2. Never take notes verbaitum. Always put in your own words. If you can't, you don't understand it good enough.
3. Learn from video courses for efficently than Books