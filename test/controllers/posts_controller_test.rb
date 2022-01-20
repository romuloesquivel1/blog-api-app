require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @david = users(:david)
    @user = users(:leecrey)
    @post = posts(:first)
  end

  test 'should get index' do
    get posts_url, as: :json
    assert_response :success
  end

  test 'should be un authorized' do
    token = @user.token_get + 'xyz'
    hash = { content: @post.content, user_id: @post.user_id }
    post posts_url, headers: { Authorization: token },
                    params: { post: hash },
                    as: :json

    assert_response :unauthorized
  end

  test 'should create post' do
    token = @user.token_get
    assert_difference('Post.count') do
      post posts_url, headers: { Authorization: token },
                      params: { post: { content: @post.content, user_id: @post.user_id } },
                      as: :json
    end

    assert_response :created
  end

  test 'should show post' do
    get post_url(@post), as: :json
    assert_response :success
  end

  test 'should be unauthorized' do
    hash = { content: @post.content, user_id: @post.user_id }
    patch post_url(@post), params: { post: hash }, as: :json
    assert_response :unauthorized
  end

  test 'should update post' do
    token = @user.token_get
    hash = { content: @post.content, user_id: @post.user_id }
    patch post_url(@post), headers: { Authorization: token },
                            params: { post: hash }, as: :json
    assert_response :success
  end

  test 'should not be destroyed' do
    # david is trying to delete leecrey's post
    token = @david.token_get
    assert_difference('Post.count', 0) do
      delete post_url(@post), headers: { Authorization: token }, as: :json
    end

    assert_response :forbidden
  end

  test 'should destroy post' do
    token = @user.token_get
    assert_difference('Post.count', -1) do
      delete post_url(@post), headers: { Authorization: token }, as: :json
    end

    assert_response :no_content
  end
end
