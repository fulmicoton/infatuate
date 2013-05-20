infatuate = require 'infatuate'
argv = require('optimist').argv

text_length = argv.size ? 1000
input_filepath = argv.input

if not input_filepath?
    console.log "Usage: "
    console.log "   infatuate --input utf8_textfile --size <textlength>"
else
    fs = require 'fs'
    text = fs.readFileSync input_filepath, {'encoding': 'utf-8'}
    model = infatuate.learn text
    console.log model.draw_text text_length