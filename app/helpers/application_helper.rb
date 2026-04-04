module ApplicationHelper
  include Pagy::Frontend

  # Contenu HTML issu de TinyMCE (couleurs, tailles, tableaux, etc.)
  ALLOWED_HTML_TAGS = %w[
    p br strong em b i u s strike span div h1 h2 h3 h4 h5 h6 ul ol li
    a blockquote pre code img table thead tbody tr th td hr sub sup figure figcaption colgroup col
  ].freeze

  ALLOWED_HTML_ATTRS = %w[
    href title target rel class style colspan rowspan src alt width height
    border cellpadding cellspacing align valign id scope
  ].freeze

  def html_content(html)
    return "".html_safe if html.blank?

    cleaned = html.to_s.gsub(/<!--.*?-->/m, "")
    sanitize(
      cleaned,
      tags: ALLOWED_HTML_TAGS,
      attributes: ALLOWED_HTML_ATTRS
    )
  end
end
