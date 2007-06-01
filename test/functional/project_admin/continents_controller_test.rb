require File.dirname(__FILE__) + '/../../test_helper'
require 'project_admin/continents_controller'

# Re-raise errors caught by the controller.
class ProjectAdmin::ContinentsController; def rescue_action(e) raise e end; end

class ProjectAdmin::ContinentsControllerTest < Test::Unit::TestCase
  fixtures :project_admin_continents

  def setup
    @controller = ProjectAdmin::ContinentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:project_admin_continents)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_continent
    old_count = ProjectAdmin::Continent.count
    post :create, :continent => { }
    assert_equal old_count+1, ProjectAdmin::Continent.count
    
    assert_redirected_to continent_path(assigns(:continent))
  end

  def test_should_show_continent
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_continent
    put :update, :id => 1, :continent => { }
    assert_redirected_to continent_path(assigns(:continent))
  end
  
  def test_should_destroy_continent
    old_count = ProjectAdmin::Continent.count
    delete :destroy, :id => 1
    assert_equal old_count-1, ProjectAdmin::Continent.count
    
    assert_redirected_to project_admin_continents_path
  end
end
