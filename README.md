# Infatuate

Give it a sample text and it will create arbitrarily long random text.
It can be used as a library in the browser or in NodeJS, or as in command line using its cli.
See [this blogspot](http://fulmicoton.com/posts/shannon-markov/) for more information.


# Command line usage

    sudo npm install infatuate -g
    infatuate --input pride_and_prejudice.txt --size 1000


# Library usage in the browser
    

Include lib/infatuate.js, in your webpage and the following should work.
    
    var some_long_text = /*...*/;
    var myModel = infatuate.learn(some_long_text);
    console.log(myModel.generate_text(500));


# Library usage in the NodeJS

In NodeJS, after running
    
    npm install infatuate

you should be able to use by require the infatuate package.

    infatuate = require('infatuate');

    var some_long_text = /*...*/;
    var myModel = infatuate.learn(some_long_text);
    console.log(myModel.generate_text(500));