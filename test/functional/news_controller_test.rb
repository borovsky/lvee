require File.dirname(__FILE__) + '/../test_helper'

class NewsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:news)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_news
    assert_difference('News.count') do
      post :create, :news => { }
    end

    assert_redirected_to news_path(assigns(:news))
  end

  def test_should_show_news
    get :show, :id => news(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => news(:one).id
    assert_response :success
  end

  def test_should_update_news
    put :update, :id => news(:one).id, :news => { }
    assert_redirected_to news_path(assigns(:news))
  end

  def test_should_destroy_news
    assert_difference('News.count', -1) do
      delete :destroy, :id => news(:one).id
    end

    assert_redirected_to news_path
  end
end
