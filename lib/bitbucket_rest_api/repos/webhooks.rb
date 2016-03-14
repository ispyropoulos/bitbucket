# encoding: utf-8

module BitBucket
  class Repos::Webhooks < API
    VALID_KEY_PARAM_NAMES = %w(description url active events).freeze
    REQUIRED_KEY_PARAM_NAMES = %w(description url).freeze

    # Gets the information associated with a repository's webhook.
    #
    # = Examples
    #  bitbucket = BitBucket.new
    #  bitbucket.repos.webhooks.get 'user-name', 'repo-name', 'uuid'
    def get(user_name, repo_name, uuid, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of(uuid)
      normalize! params

      get_request("/2.0/repositories/#{user}/#{repo.downcase}/hooks/#{uuid}", params)
    end
    alias :find :get

    # Gets a list of the webhooks for a repository and the information associated
    # with each webhook.
    #
    # = Examples
    #  bitbucket = BitBucket.new
    #  bitbucket.repos.webhooks.list 'user-name', 'repo-name'
    def list(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params

      response = get_request("/2.0/repositories/#{user}/#{repo.downcase}/hooks", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Creates a new webhook for the specified repository.
    #
    # = Parameters
    # *<tt>description</tt> - A user-defined description of the webhook.
    # *<tt>url</tt> - The URL where Bitbucket posts the event payload.
    # *<tt>active</tt> - <tt>true</tt> or <tt>false</tt> to specify whether the hook is active. Default is <tt>true</tt>.
    # *<tt>events</tt> - The type of event you want to associate with the hook. Refer to the Event Payloads for more information. Default is Repository Push events.
    #
    # = Examples
    # bitbucket = BitBucket.new
    # bitbucket.repos.webhooks.create 'user-name', 'repo-name',
    #   :description => "Webhook Description",
    #   :url         => "https://webhookendpoint.com/",
    #   :active      => true,
    #   :events      => ["repo:push", "issue:created", "issue:updated"]
    #
    def create(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params
      filter! VALID_KEY_PARAM_NAMES, params
      assert_required_keys(REQUIRED_KEY_PARAM_NAMES, params)

      post_request("/2.0/repositories/#{user}/#{repo.downcase}/hooks", params)
    end

    # Updates a specific webhook.
    #
    # = Parameters
    # *<tt>description</tt> - A user-defined description of the webhook.
    # *<tt>url</tt> - The URL where Bitbucket posts the event payload.
    # *<tt>active</tt> - <tt>true</tt> or <tt>false</tt> to specify whether the hook is active.
    # *<tt>events</tt> - The type of event you want to associate with the hook. Refer to the Event Payloads for more information.
    #
    # = Examples
    # bitbucket = BitBucket.new
    # bitbucket.repos.webhooks.edit 'user-name', 'repo-name', 'uuid'
    #   :description => "Webhook Description",
    #   :url         => "https://webhookendpoint.com/",
    #   :active      => false,
    #   :events      => ["repo:push"]
    #
    def edit(user_name, repo_name, uuid, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of(uuid)
      normalize! params
      filter! VALID_KEY_PARAM_NAMES, params
      assert_required_keys(REQUIRED_KEY_PARAM_NAMES, params)

      put_request("/2.0/repositories/#{user}/#{repo.downcase}/hooks/#{uuid}", params)
    end

    # Deletes the specified webhook.
    #
    # = Examples
    #  bitbucket = BitBucket.new
    #  bitbucket.repos.webhooks.delete 'user-name', 'repo-name', 'uuid'
    def delete(user_name, repo_name, uuid, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of(uuid)
      normalize! params

      delete_request("/2.0/repositories/#{user}/#{repo.downcase}/hooks/#{uuid}", params)
    end
  end
end
