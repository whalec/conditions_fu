conditions_fu
    by Cameron Barrie
    http://wiki.github.com/whalec/conditions_fu

== DESCRIPTION:

A little DSL to allow you to map url parameters to an Active Record conditions array.

== TODO:
Everything. I've only onlined my intentions here.

== FEATURES/PROBLEMS:

  allows you to map rules to url parameters when posting from a form with a get. 
  
  i.e. if you're request was:
  http://local.host/users/search?admin=1&email=camwritescode
  
  it would map to an active record conditions array like
  
  ["admin IS ? and email ~* ?", true, 'camwritescode']

== SYNOPSIS:

ConditionsFu::Builder(:user).blueprint do |params|
  is_true     "admin"             => params[:content] if params[:admin]  == "1"
  includes    "parents_last_name" => params[:content] if params[:filter] == "surname" && !params[:content].blank?
  is_like     "parent_email"      => params[:content] if params[:filter] == "emails" && !params[:content].blank?
  is_like     "nickname"          => params[:content] if params[:filter] == "nickname" && !params[:content].blank?
  is_like     "locations.name"    => params[:content] if params[:filter] == "location" && !params[:content].blank?
  binding(:or) do
    includes    "last_name"       => params[:content] if params[:filter] == "surname" && !params[:content].blank?
    is_like     "email"           => params[:content] if params[:filter] == "emails" && !params[:content].blank?
  end  
end

User.find(:all, :conditions => ConditionsFu::Builder.conditions(params))

or you can also not make a "blueprint" and use it in a controller directly

conditions = ConditionsFu::Builder.conditions(params) do
  is_true     "admin"             => params[:content] if params[:admin]  == "1"
  includes    "parents_last_name" => params[:content] if params[:filter] == "surname" && !params[:content].blank?
end

User.find(:all, :conditions => conditions.to_active_record)


== REQUIREMENTS:

Currently it only works for Postgres as it's the only DB that I work with. Patch are happily accepted though :D

== INSTALL:

sudo gem install conditions_fu

== LICENSE:

(The MIT License)

Copyright (c) 2009 FIXME (different license?)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
