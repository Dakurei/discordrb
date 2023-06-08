# frozen_string_literal: true

# API calls for Webhook object
module Discordrb::API::Webhook
  module_function

  # Get a webhook
  # https://discord.com/developers/docs/resources/webhook#get-webhook
  def webhook(token, webhook_id)
    Discordrb::API.request(
      :webhooks_wid,
      nil,
      :get,
      "#{Discordrb::API.api_base}/webhooks/#{webhook_id}",
      Authorization: token
    )
  end

  # Get a webhook via webhook token
  # https://discord.com/developers/docs/resources/webhook#get-webhook-with-token
  def token_webhook(webhook_token, webhook_id)
    Discordrb::API.request(
      :webhooks_wid,
      nil,
      :get,
      "#{Discordrb::API.api_base}/webhooks/#{webhook_id}/#{webhook_token}"
    )
  end

  # Execute a webhook via token.
  # https://discord.com/developers/docs/resources/webhook#execute-webhook
  def token_execute_webhook(webhook_token, webhook_id, wait = false, content = nil, username = nil, avatar_url = nil, tts = nil, file = nil, embeds = nil, allowed_mentions = nil, flags = nil, components = nil, attachments = nil)
    body = { content: content, username: username, avatar_url: avatar_url, tts: tts, embeds: embeds&.map(&:to_hash),  allowed_mentions: allowed_mentions, flags: flags, components: components }

    payload = body.to_json

    # since this method signature already had 'file' param, we'll prefer deprecated behavior for now
    if file
      payload = { file: file, payload_json: payload }
    elsif attachments
      files = [*0...attachments.size].zip(attachments).to_h
      payload = { **files, payload_json: payload }
    end

    headers = { content_type: :json } unless attachments || file

    Discordrb::API.request(
      :webhooks_wid,
      webhook_id,
      :post,
      "#{Discordrb::API.api_base}/webhooks/#{webhook_id}/#{webhook_token}?wait=#{wait}",
      payload,
      headers
    )
  end

  # Update a webhook
  # https://discord.com/developers/docs/resources/webhook#modify-webhook
  def update_webhook(token, webhook_id, data, reason = nil)
    Discordrb::API.request(
      :webhooks_wid,
      webhook_id,
      :patch,
      "#{Discordrb::API.api_base}/webhooks/#{webhook_id}",
      data.to_json,
      Authorization: token,
      content_type: :json,
      'X-Audit-Log-Reason': reason
    )
  end

  # Update a webhook via webhook token
  # https://discord.com/developers/docs/resources/webhook#modify-webhook-with-token
  def token_update_webhook(webhook_token, webhook_id, data, reason = nil)
    Discordrb::API.request(
      :webhooks_wid,
      webhook_id,
      :patch,
      "#{Discordrb::API.api_base}/webhooks/#{webhook_id}/#{webhook_token}",
      data.to_json,
      content_type: :json,
      'X-Audit-Log-Reason': reason
    )
  end

  # Deletes a webhook
  # https://discord.com/developers/docs/resources/webhook#delete-webhook
  def delete_webhook(token, webhook_id, reason = nil)
    Discordrb::API.request(
      :webhooks_wid,
      webhook_id,
      :delete,
      "#{Discordrb::API.api_base}/webhooks/#{webhook_id}",
      Authorization: token,
      'X-Audit-Log-Reason': reason
    )
  end

  # Deletes a webhook via webhook token
  # https://discord.com/developers/docs/resources/webhook#delete-webhook-with-token
  def token_delete_webhook(webhook_token, webhook_id, reason = nil)
    Discordrb::API.request(
      :webhooks_wid,
      webhook_id,
      :delete,
      "#{Discordrb::API.api_base}/webhooks/#{webhook_id}/#{webhook_token}",
      'X-Audit-Log-Reason': reason
    )
  end

  # Get a message that was created by the webhook corresponding to the provided token.
  # https://discord.com/developers/docs/resources/webhook#get-webhook-message
  def token_get_message(webhook_token, webhook_id, message_id)
    Discordrb::API.request(
      :webhooks_wid_messages_mid,
      webhook_id,
      :get,
      "#{Discordrb::API.api_base}/webhooks/#{webhook_id}/#{webhook_token}/messages/#{message_id}"
    )
  end

  # Edit a webhook message via webhook token
  # https://discord.com/developers/docs/resources/webhook#edit-webhook-message
  def token_edit_message(webhook_token, webhook_id, message_id, content = nil, embeds = nil, allowed_mentions = nil, components = nil, attachments = nil)
    data = { content: content, embeds: embeds, allowed_mentions: allowed_mentions, components: components }

    # TODO: It will be necessary to add the ability to completely remove attachments from a message by setting the value to null in the payload. (In this method or elsewhere)
    # https://discord.com/developers/docs/reference#editing-message-attachments

    payload = data.to_json
    if attachments
      files = [*0...attachments.size].zip(attachments).to_h
      payload = { **files, payload_json: payload }
    end

    headers = { content_type: :json } unless attachments

    Discordrb::API.request(
      :webhooks_wid_messages,
      webhook_id,
      :patch,
      "#{Discordrb::API.api_base}/webhooks/#{webhook_id}/#{webhook_token}/messages/#{message_id}",
      payload,
      headers
    )
  end

  # Delete a webhook message via webhook token.
  # https://discord.com/developers/docs/resources/webhook#delete-webhook-message
  def token_delete_message(webhook_token, webhook_id, message_id)
    Discordrb::API.request(
      :webhooks_wid_messages,
      webhook_id,
      :delete,
      "#{Discordrb::API.api_base}/webhooks/#{webhook_id}/#{webhook_token}/messages/#{message_id}"
    )
  end
end
