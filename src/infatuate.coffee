

PUNCTUATION = /([\.,;!?])/g
WHITESPACES = /\s+/

tokenize = (corpus)->
  # A simple tokenizer splitting on punctuation and whitespaces.
  corpus = corpus.replace(PUNCTUATION, " $1 ")
  corpus = corpus.replace /(Mr|Mrs|Pr)\./g, "$1 "
  corpus = corpus.replace /("|--)/g, " "
  corpus.split WHITESPACES

class DefaultDict
    
    # A simple implementation of Python's
    # defaultdict.
    constructor: (@default_value)->
        @c = {}

    get: (k)->
      # if the key is not within the dictionary
      # automatically creates an entry.
      if not @c[k]?
          @c[k] = @default_value()
      @c[k]

    set: (k,v)->
        @c[k]=v

    items: ->
      # Returns the list of [key,value]
      ([k,v] for k,v of @c)

class Counter extends DefaultDict

    constructor: ->
        @c = {}
        @default_value = -> 0
    inc: (k, count=1)->
        @c[k] = @get(k) + count






binary_search_aux = (arr, target, start, end)->
  if arr[start] >= target
      start
  else if (end - start) <= 1
      end
  else
      middle = (start + end - (start+end) % 2) / 2
      if arr[middle] >= target
          binary_search_aux arr, target, start, middle
      else
          binary_search_aux arr, target, middle, end

binary_search = (arr, target)->
  # Assuming that arr is sorted,
  # returns the smallest id, such that 
  # arr[id] >= target
  binary_search_aux arr, target, 0, arr.length







class Distribution

    constructor: (weights)->
      # Takes a list of [value, weight] as
      # argument.  See draw
      @total = 0
      @values = []
      @boundaries = []
      for [value,weight] in weights
        @values.push value
        @total += weight
        @boundaries.push @total

    draw: ->
      # Returns a random value
      # The bigger the weight associated to 
      # the value, the greater the chance
      # of appearance.
      target = Math.random() * @total
      value_id = binary_search @boundaries, target
      @values[value_id]



all = (predicate, elements)->
  # return true iff all the elements
  # match the predicate
  for el in elements
    if not predicate el
      return false
  true

add_space = (token)->
  # add space before token if it is
  # required.
  if token in ".,"
    token
  else
    " " + token


count_triplets = (tokens)->
  # Returns a counter for all the 
  # triplets of tokens in the form of 
  # a three level map :
  #   token -> token -> token -> count
  triplet_counter = new DefaultDict (-> new DefaultDict (-> new Counter()))
  for start in [0...tokens.length-3]
      [tok1, tok2, tok3] = tokens[start...start+3]
      triplet_counter.get(tok1).get(tok2).inc(tok3)
  triplet_counter

class LanguageModel

  # This object represents a 
  # language model. It is able to 
  # generate random sentences out of it.
  constructor: (@trigrams, @starting_bigrams)->

  draw_tokens: ->
    # Generates a sequence of token 
    # finishing by "."
    [w1, w2] = @starting_bigrams.draw()
    tokens = [w1, w2]
    while w2 != "."
      [w1, w2] = [ w2, @trigrams.get(w1)[w2].draw() ]
      tokens.push w2
    if 3 < tokens.length < 20
      tokens
    else
      @draw_tokens()

  generate_sentence: ->
    # Returns a random sentence
    tokens = @draw_tokens()
    ( add_space(token) for token in tokens).join("").trim()


  generate_text: (min_length)->
    # Returns a text of a length of around
    # min_length.
    text = ""
    while text.length < min_length
      text += @generate_sentence() + " "
    text


if exports?
  root = exports
else
  @infatuate = {}
  root = @infatuate

root.learn =  (text)->
  # tokenize our text
  tokens = tokenize text+"."
  # creates a triplet counter
  triplet_counter = count_triplets tokens
  # computes the trigram distribution
  markov_model = new DefaultDict -> {}
  for w1, doublet_counter of triplet_counter.c
    for w2, word_counts of doublet_counter.c
      token_distribution = new Distribution word_counts.items()
      markov_model.get(w1)[w2] = token_distribution
  # Given a triplet counter map,
  # computes a distribution of starting
  # bigram
  bigrams = []
  for k1, word_counter of triplet_counter.get(".").c
    for k2, word_count of word_counter.c
      bigrams.push [ [k1, k2], word_count ]
  bigram_distribution = new Distribution bigrams
  new LanguageModel markov_model, bigram_distribution
