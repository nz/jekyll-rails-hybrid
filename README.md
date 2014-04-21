# The Strange Case of Dr Jekyll and Mr Rails

I like Rails. And I increasingly _really_ like Jekyll. The "why" of this particular mashup deserves a much more thorough writeup. For now, here's the "what."

_(Up-front disclosure: I don't use this in production [anymore]; see the end of this readme for alternate takes on a similar theme.)_

## What is this thing?

### 1. A Simple Rails App

Look around. It's Rails.

### 2. A Simple Jekyll App

But wait, there's more! According to this `_config.yml`, there's a Jekyll app hiding mostly in `app/static`! And it's generating the entirety of the Rails app's `public` directory!

There are some other opinions in the `_config.yml` file (Redcloth, Pygments), but it's all pretty minimal right now.

### 3. A Bit of Glue

Because I rather like the Rails asset pipeline, and want to use _all_ of its strengths from within Jekyll, I wrote a small Jekyll plugin to provide an `asset_path` tag. This tag uses the Rails environment's own Sprockets environment in `Rails.application.assets` to find assets and their digest paths.

Boom: Jekyll is using the Rails apps stylesheets, in all their compiled, minified, gzipped, digested glory.

Finally, I straight-up _.gitignore_ the `public` directory. I then wire up a simple rake task to run a naive Jekyll build before the `assets:precompile` task presumably being called elsewhere in your production deploy scripts.

### 4. A Bit of Exposition

This app is a bit of exploration and experimentation. There is more exposition to come based on what I learn in here. Hopefully the result will describe a standard, de facto way for integrating Jekyll into a Rails app.

For now, feedback is welcome! In particular, I want to talk about:

- **Who cares?** Should I bother blogging about this thing? Is it useful? Did someone else already do it and my Google-fu failed me?
- **Conventions and configurations.** Can some of this be done with less configuration? May be a tall order given the amount of configuration in here, but I'm always up for improvement.
- **Hard-coded assumptions.** In particular, I'm looking at the hardcoded `/assets` in my `asset_path` tag, and the (lack of) options in the `jekyll:build` task. Mostly late evening laziness on my part. Can these be made more flexible and robust?
- **Future proofiness.** In future versions of Rails and Jekyll, where will this thing break? Is there some better encapsulation to be had in here?

Hit me up on the Twitters: [@nz_](http://twitter.com/nz_)

## On Heroku

If you're hosting on Heroku you won't be able to lean on the `assets:precompile` dependency for the jekyll 
task so you should delete the `jekyll.rake` task file and, instead, precompile your assets locally and check 
them into your repo. Otherwise the files would still be compiled on deploy, but would disappear as files not
checked into git are eventually deleted.

### A note about local compilation

When running `rake assets:precompile` it will do so within your *production* environment. Remember that assets
are given a different digest per environment. If you compile jekyll files without `RAILS_ENV=production` the
asset_path plugin will instead be run in a `development` context. As a result the digests will not match. The lesson?
Run both with RAILS_ENV set as production.

```
rake assets:precompile # RAILS_ENV=production is optional here
RAILS_ENV=production jekyll build
```

## Try it out

```
git clone git@github.com:nz/jekyll-rails-hybrid.git
cd jekyll-rails-hybrid
bundle install
jekyll build
rails server
```

Enjoy!

# Other Approaches

- See @metaskills tackle this challenge from a different direction, in his blog article, [Jekyll-Style Blogging On Rails](https://homemarks.com/blog/2014-04-19-jekyll-style-blogging-on-rails)

Apparently this repo ranks well on Google for "jekyll rails" — if you have other links to similar ideas, I'll happily add them here, just send me a pull request.
