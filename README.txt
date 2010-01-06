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

ConditionsFu::Builder.blueprint(:user) do
  is_true("admin" => params[:admin])
  includes({:parents_last_name => params[:surname]}, :or) do
    includes({:last_name => params[:surname]}, :or)
    is_like("parent_email" => params[:email]) do
      is_true(:child => params[:child])
    end
  end
end
params = {:surname => "Barrie", :email => "cam@snepo.com", :child => false, :admin => true}
conditions = ConditionsFu::Builder.make(params) 
# => ["admin = ? AND (parents_last_name ~* ? OR last_name ~* ? OR (parent_email ILIKE ? AND child = ?))", true, "Barrie", "Barrie", "%cam@snepo.com%", true]

So then you can
User.find(:all, :conditions => ConditionsFu::Builder.make(params))

For more examples check the specs directory.

== REQUIREMENTS:

Currently it only works for Postgres as it's the only DB that I work with. Patches are happily accepted though :D

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
