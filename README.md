# The Strange Case of Dr Jekyll and Mr Rails

I like Rails. And I increasingly _really_ like Jekyll. The "why" of particular mashup deserves a much more thorough writeup. For now, here's the "what."

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

A bit more exposition to come. For now, feedback is welcome!

In particular, I want to talk about:

- **Conventions and configurations.** Can some of this be done with less configuration?
- **Hard-coded assumptions.** I'm looking at the hardcoded `/assets` in my `asset_path` tag, and the (lack of) options in the `jekyll:build` task. Can these be made more flexible and robust?
- **Future proofiness:** do you see any smells?
- **Who cares?** Should I blog about this thing?

Hit me up on the Twitters: [@nz_](http://twitter.com/nz_)

## Try it out

```
git clone git@github.com:nz/jekyll-rails-hybrid.git
cd jekyll-rails-hybrid
bundle install
jekyll build
rails server
```

Enjoy!