module PdfExport
  class MFPDF < TCPDF::Renderer
    def add_text_wrap(x, y, w, txt, fh, align)
      set_xy(x, y)
      set_font("FreeSans", "", fh)
      if(get_string_width(txt) > w)
        set_font("FreeSans", "", fh / 1.5)
      end
      cell(w, 0, txt, 0, 0, align)
    end

    def w_pt
      @w_pt
    end

    def h_pt
      @h_pt
    end

    def l_margin
      @l_margin
    end

    def t_margin
      @t_margin
    end
  end

  BADGES_PER_ROW = 2
  BADGES_PER_COLUMN = 5

  def self.badges(badges, theme)
    pdf = MFPDF.new("P", "pt")
    pdf.set_font("FreeSans")
    pdf.set_title("")
    pdf.set_auto_page_break(false)
    pdf.set_margins((72/25.4) * 15, (72/25.4) * 10)

    height = (pdf.h_pt - 2 * pdf.t_margin) / BADGES_PER_COLUMN
    width = (pdf.w_pt -  2 * pdf.l_margin) / BADGES_PER_ROW

    start_pos_x = pdf.l_margin
    start_pos_y = pdf.t_margin

    pdf.set_draw_color(0,0,0)

    if theme
      shishki = theme.file_path_if_exists("badges/shishky.png")
      logo = theme.file_path_if_exists("badges/logo.png")
    end

    shishki ||= "#{Rails.root}/media/shishky.png"
    logo ||= "#{Rails.root}/media/logo2012.png"

    badges.each_with_index do |b, idx|
      if(idx % (BADGES_PER_ROW * BADGES_PER_COLUMN) == 0)
        pdf.add_page
      end

      sx = start_pos_x + width * (idx % BADGES_PER_ROW)
      sy = start_pos_y + height * ((idx / BADGES_PER_ROW) % BADGES_PER_COLUMN)

      pdf.rect(sx, sy, width, height)
      pdf.image(shishki, sx+6, sy + 10, 90)
      pdf.image(logo, sx + 110, sy + 30, 140)
      pdf.add_text_wrap(sx + 100, sy + 10, width-110, b.tags, 12, 'C')
      pdf.add_text_wrap(sx + 20, sy + height - 50, width-40, b.top, 15, 'C')
      pdf.add_text_wrap(sx + 20, sy + height - 20, width-40, b.bottom, 12, 'C')
    end

    pdf.output
  end

end
