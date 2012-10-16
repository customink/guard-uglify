# guard-uglify
Provides [guard](https://github.com/guard/guard) support for uglifying javascript files via [uglifier](https://github.com/lautis/uglifier)

## Installation
Add the following to your <tt>Gemfile</tt>

    gem 'uglifier', '~> 1.3.0'
    gem 'guard-uglify', '~> 0.3.0', :git => 'git://github.com/customink/guard-uglify.git'

## Usage

Generate a <tt>Guardfile</tt> if you have not done so already:

    guard init

Otherwise, append the uglify template to your <tt>Guardfile</tt>:

    guard init uglify

which will add this to your <tt>Guardfile</tt>:

    guard 'uglify', :input => 'app/assets/javascripts', :output => "public/javascripts" do
      watch (%r{foo.js})
      watch (%r{bar.js})
    end

Changes to files that are being watched under the input directory will be uglified, have an extension appended, and then output to the output directory.  With the stock example, updates to <tt>app/assets/javascripts/foo.js</tt> and <tt>app/assets/javascripts/bar.js</tt> will result in <tt>public/javascripts/foo.min.js</tt> and <tt>public/javascripts/bar.min.js</tt> being written.

## Options
* <tt>extension</tt> - Sets the minified extension that is appended. Default is min. Ex: <tt>foo.js</tt> => <tt>foo.min.js</tt>
* <tt>all_on_start</tt> - Determines if all target files should be minified on start.  Default is false.

## Credits

Modified from [guard-uglify](https://github.com/pferdefleisch/guard-uglify) by Aaron Cruz
