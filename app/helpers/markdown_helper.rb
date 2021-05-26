require 'rouge/plugins/redcarpet'

class HTML < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end

module MarkdownHelper
  def markdown(text)
    options = {
      # no_images:     true,
      no_styles:     true,
      with_toc_data: true,
      hard_wrap:     true
    }

    extensions = {
      no_intra_emphasis:   true,
      tables:              true,
      fenced_code_blocks:  true,
      autolink:            true,
      lax_spacing:         true,
      space_after_headers: true,
      escape_html:         true, # xss対策 全てのHTMLタグをエスケープ(filter_htmlより優先) 
      quote:               true  # xss対策 引用符を表す「""」を認識
    }

    unless @markdown
      # Redcarpet::Render::HTML => HTML に変更
      renderer = HTML.new(options)
      @markdown = Redcarpet::Markdown.new(renderer, extensions)
    end

    @markdown.render(text).html_safe
  end

  def toc(text)
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML_TOC.new(nesting_level: 3)
    )
    markdown.render(text).html_safe
  end
end