# frozen_string_literal: true

# Post
#
# Attributes:
#   agent_id [Agent], optional
#   body [text]
#   created_at [DateTime]
#   data [jsonb]
#   ip_address_id [IpAddress], optional
#   featured [boolean]
#   lead [text], optional
#   publication_time [datetime]
#   rating [float]
#   simple_image_id [SimpleImage], optional
#   slug [string]
#   source_link [string], optional
#   source_name [string], optional
#   title [string]
#   updated_at [DateTime]
#   user_id [User]
#   uuid [uuid]
#   video [boolean]
#   view_count [integer]
#   visible [boolean]
class Post < ApplicationRecord
  include BelongsToSite
  include Checkable
  include HasOwner
  include HasSimpleImage
  include HasTrack
  include HasUuid
  include MetaTexts
  include Toggleable

  TITLE_LIMIT = 255
  URL_PATTERN = %r{https?://([^/]+)/?.*}

  toggleable :visible, :featured
  paginates_per 12

  belongs_to :user, optional: true
  has_many :post_attachments, dependent: :destroy
  has_many :post_images, dependent: :destroy
  has_many :post_links, dependent: :destroy
  has_many :post_notes, dependent: :destroy
  has_many :post_references, dependent: :destroy

  after_initialize { self.publication_time = Time.now if publication_time.nil? }
  before_validation :prepare_slug
  before_validation :prepare_source_names

  validates_presence_of :title, :body
  validates_length_of :title, maximum: TITLE_LIMIT
  validates_length_of :lead, maximum: LEAD_LIMIT
  validates_length_of :source_link, maximum: META_LIMIT
  validates_length_of :source_name, maximum: META_LIMIT

  scope :featured, -> { where(featured: true) }
  scope :visible, -> { where(visible: true) }
  scope :recent, -> { order('publication_time desc') }
  scope :popular, -> { order('rating desc') }
  scope :published, -> { where('publication_time <= current_timestamp') }
  scope :search, ->(v) { where("posts_tsvector(title, lead, body) @@ phraseto_tsquery('russian', ?)", v) }
  scope :list_for_visitors, -> { visible.published.includes(:simple_image, :user).recent }
  scope :list_for_administration, -> { includes(:simple_image, :user).order('id desc') }
  scope :list_for_owner, ->(v) { includes(:simple_image, :user).owned_by(v).recent }
  scope :archive, -> { f = Arel.sql('date(publication_time)'); distinct.order(f).pluck(f) }
  scope :posted_after, ->(v) { where('publication_time >= ?', v) }
  scope :pubdate, ->(v) { where('date(publication_time) = ?', v) }
  scope :f_visible, ->(f) { where(visible: f.to_i.positive?) unless f.blank? }
  scope :filtered, ->(f) { f_visible(f[:visible]) }

  # @param [Integer] page
  # @param [Hash] filter
  def self.page_for_administration(page = 1, filter = {})
    filtered(filter).list_for_administration.page(page)
  end

  # @param [Integer] page
  # @param [Integer] per_page
  def self.page_for_visitors(page = 1)
    list_for_visitors.page(page)
  end

  # @param [User] user
  # @param [Integer] page
  def self.page_for_owner(user, page = 1)
    list_for_owner(user).page(page)
  end

  def self.entity_parameters
    %i[
      body featured lead publication_time rating simple_image_id
      source_name source_link title video visible
    ]
  end

  def world_url
    "/posts/#{id}-#{slug}"
  end

  def text_for_link
    title
  end

  private

  def prepare_slug
    postfix = (created_at || Time.now).strftime('%d%m%Y')

    self.slug = "#{Canonizer.transliterate(title.to_s)}_#{postfix}"

    slug_limit = 200 + postfix.length + 1
    self.slug = slug.downcase[0..slug_limit]
  end

  def prepare_source_names
    return unless source_name.blank? && !source_link.blank?

    self.source_name = URI.parse(source_link).host
  rescue URI::InvalidURIError
    self.source_name = URL_PATTERN.match(source_link)[1]
  end
end
