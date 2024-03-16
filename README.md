# Audio File Parser

## Dependencies

- Ruby `3.1.2`
- Bundler `2.5.6`

## Usage

- To install bundler run `gem install bundler -v '2.5.6'`
- Install dependencies run `bundle install`
- Run app `ruby audio_parser.rb <input_dir>`

### Note

There is optional input `output_directory`, which is `output` by default 

Run `ruby audio_parser.rb <input_dir> <output_dir>`


## Testing

Test is covering the behaviour of the two main components `GetMetaDataFromDirectory` & `StoreMetaData`

To run test run `bundle exec rspec`

