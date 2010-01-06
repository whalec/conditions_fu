require File.join(File.dirname(__FILE__), %w[../ spec_helper])
describe ConditionsFu::Builder do
  
  it "should initialize" do
    ConditionsFu::Builder.blueprint(:user) do
      is_true     "admin"             => params[:content] if params[:admin]  == "1"
      includes    "parents_last_name" => params[:content] if params[:filter] == "surname" && !params[:content].nil?
      is_like     "parent_email"      => params[:content] if params[:filter] == "emails" && !params[:content].nil?
      is_like     "nickname"          => params[:content] if params[:filter] == "nickname" && !params[:content].nil?
      is_like     "locations.name"    => params[:content] if params[:filter] == "location" && !params[:content].nil?
    end
  end
  
  it "should be able to return an ActiveRecord conditions array" do    
    params = {:admin => "1", :filter => "emails", :content => "cameron@snepo.com"}
    parameters = ConditionsFu::Builder.make(:user, params)
    parameters.should eql(["admin = ? AND parent_email ILIKE ?", true, "%cameron@snepo.com%"])
  end
  
  it "should bind conditions" do
    ConditionsFu::Builder.blueprint(:master) do
      is_true     "admin"             => params[:admin]
      includes    "parents_last_name" => params[:surname]
      is_like     "parent_email"      => params[:email]
      is_like     "nick"              => params[:nickname]
      is_like     "locations.name"    => params[:location]
    end
    
    params = {:admin => "1", :surname => "Barrie", :email => "snepo.com", :nickname => "whalec", :location => "Annandale"}
    parameters = ConditionsFu::Builder.make(:master, params)
    parameters.should eql(["admin = ? AND parents_last_name ~* ? AND parent_email ILIKE ? AND nick ILIKE ? AND locations.name ILIKE ?", true, "Barrie", "%snepo.com%", "%whalec%", "%Annandale%"])
  end
  
  it "should bind only conditions that are passed in" do
    ConditionsFu::Builder.blueprint(:master) do
      is_true     "admin"             => params[:admin]
      includes    "parents_last_name" => params[:surname]
      is_like     "parent_email"      => params[:email]
      is_like     "nick"              => params[:nickname]
      is_like     "locations.name"    => params[:location]
    end
    
    params = {:admin => "1", :surname => "Barrie"}
    parameters = ConditionsFu::Builder.make(:master, params)
    parameters.should eql(["admin = ? AND parents_last_name ~* ?", true, "Barrie"])
  end
  
  it "should be able to bind conditions with an OR statement" do
    ConditionsFu::Builder.blueprint(:or_binding) do
      is_true("admin" => params[:admin])
      includes({:parents_last_name => params[:surname]}, :or) do
        includes({:last_name => params[:surname]})
      end
      is_like("nick" => params[:nickname])
      is_like("locations.name" => params[:location])
      is_like("parent_email" => params[:email])
    end
    
    params = {:surname => "Barrie", :email => "cam@snepo.com", :admin => true}
    parameters = ConditionsFu::Builder.make(:or_binding, params)
    parameters.should eql(["admin = ? AND (parents_last_name ~* ? OR last_name ~* ?) AND parent_email ILIKE ?", 
                          true, "Barrie", "Barrie", "%cam@snepo.com%"])
  end
  
  it "should bind and number of conditions together in parenthesis" do
    ConditionsFu::Builder.blueprint(:or_binding) do
      is_true("admin" => params[:admin])
      includes({:parents_last_name => params[:surname]}, :or) do
        includes({:last_name => params[:surname]}, :or)
        is_like("parent_email" => params[:email]) do
          is_true(:child => params[:child])
        end
      end
    end
    
    params = {:surname => "Barrie", :email => "cam@snepo.com", :child => false, :admin => true}
    parameters = ConditionsFu::Builder.make(:or_binding, params)
    expectation = ["admin = ? AND (parents_last_name ~* ? OR last_name ~* ? OR (parent_email ILIKE ? AND child = ?))", 
                    true, "Barrie", "Barrie", "%cam@snepo.com%", true]
    parameters.should eql(expectation)
  end
  
end