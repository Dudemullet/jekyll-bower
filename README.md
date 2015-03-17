# jekyll-bower
Jekyll bower's main goal is to easily integrate bower installed components into your jekyll website.

## installation
place the jekyll-bower.rb file inside the `_plugins` folder in your Jekylls site root directory. Now, everytime jekyll *builds* your site. bower dependencies will be copied to the `assets` folder. 

**NOTE** only files listed as *main* in each bower packages `bower.json` will be copied. Directory structure left intact.

## recommendations
In order for Jekyll to ignore bowers default installation directory. Add `bower_components` to the exclude list in your `_config.yml` file. More details on how to do that, here [documentation](http://jekyllrb.com/docs/configuration/).