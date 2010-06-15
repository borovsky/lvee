require 'iconv'

module Export
  class MFPDF < TCPDF
    def add_text_wrap(x, y, w, txt, fh, align)
      set_xy(x, y)
      set_font("FreeSans", "", fh)
      cell(w, 0, txt, 0, 0, align)
    end

    def GetWPt
      @w_pt
    end

    def GetHPt
      @h_pt
    end

    def getLMargin
      @l_margin
    end

    def getTMargin
      @t_margin
    end
  end

  module Pdf
    protected
    BADGES_PER_ROW = 2
    BADGES_PER_COLUMN = 5

    def badges_export(badges)
      pdf = MFPDF.new("P", "pt")
      pdf.SetFont("FreeSans")
      pdf.SetTitle("")
      pdf.SetAutoPageBreak(false)

      height = (pdf.GetHPt - 2 * pdf.getLMargin) / BADGES_PER_COLUMN
      width = (pdf.GetWPt -  2 * pdf.getTMargin) / BADGES_PER_ROW

      start_pos_x = pdf.getLMargin
      start_pos_y = pdf.getTMargin

      pdf.SetDrawColor(0,0,0)

      badges.each_with_index do |b, idx|
        if(idx % (BADGES_PER_ROW * BADGES_PER_COLUMN) == 0)
          pdf.AddPage
        end

        sx = start_pos_x + width * (idx % BADGES_PER_ROW)
        sy = start_pos_y + height * ((idx / BADGES_PER_ROW) % BADGES_PER_COLUMN)

        pdf.Rect(sx, sy, width, height)
        pdf.Image("#{RAILS_ROOT}/media/shishky.png", sx+6, sy + 10, 90)
        pdf.Image("#{RAILS_ROOT}/media/logo2010.png", sx + 110, sy + 30, 140)
        pdf.add_text_wrap(sx + 100, sy + 10, width-110, b.tags, 12, 'C')
        pdf.add_text_wrap(sx + 20, sy + height - 50, width-40, b.top, 15, 'C')
        pdf.add_text_wrap(sx + 20, sy + height - 20, width-40, b.bottom, 12, 'C')
      end

      pdf.Output
    end

  end
end
