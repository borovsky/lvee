class PngChecker
  def self.check_png(f, file_name)
    #Check signature
    if (f.read(8)!=137.chr + 'PNG' + 13.chr + 10.chr + 26.chr + 10.chr)
      raise ('Not a PNG file: ' + file_name);
    end
    #Read header chunk
    f.read(4);
    if (f.read(4)!='IHDR')
      raise('Incorrect PNG file: ' + file_name);
    end
    w=freadint(f);
    h=freadint(f);
    bpc=read_byte(f);
    if (bpc>8)
      raise('16-bit depth not supported: ' + file_name);
    end
    ct=read_byte(f);
    if (ct==0)
      colspace='DeviceGray';
    elsif (ct==2)
      colspace='DeviceRGB';
    elsif (ct==3)
      colspace='Indexed';
    else
      raise('Alpha channel not supported: ' + file_name);
    end
    if (read_byte(f) != 0)
      raise('Unknown compression method: ' + file_name);
    end
    if (read_byte(f)!=0)
      raise('Unknown filter method: ' + file_name);
    end
    if (read_byte(f)!=0)
      raise('Interlacing not supported: ' + file_name);
    end
    f.read(4);
    parms='/DecodeParms <</Predictor 15 /Colors ' + (ct==2 ? 3 : 1).to_s + ' /BitsPerComponent ' + bpc.to_s + ' /Columns ' + w.to_s + '>>';
    #Scan chunks looking for palette, transparency and image data
    pal='';
    trns='';
    data='';
    begin
      n=freadint(f);
      type=f.read(4);
      if (type=='PLTE')
        #Read palette
        pal=f.read( n);
        f.read(4);
      elsif (type=='tRNS')
        #Read transparency info
        t=f.read( n);
        if (ct==0)
          trns = t[1][0]
        elsif (ct==2)
          trns = t[[1][0], t[3][0], t[5][0]]
        else
          pos=t.include?(0.chr);
          if (pos!=false)
            trns = [pos]
          end
        end
        f.read(4);
      elsif (type=='IDAT')
        #Read image data block
        data << f.read( n);
        f.read(4);
      elsif (type=='IEND')
        break;
      else
        f.read( n+4);
      end
    end while(n)
    if (colspace=='Indexed' and pal.empty?)
      raise('Missing palette in ' + file_name);
    end
    return {'w' => w, 'h' => h, 'cs' => colspace, 'bpc' => bpc, 'f'=>'FlateDecode', 'parms' => parms, 'pal' => pal, 'trns' => trns, 'data' => data}
  end

  private
  def self.freadint(f)
    # Read a 4-byte integer from file
    a = f.read(4).unpack('N')
    return a[0]
  end

  def self.read_byte(f)
    r = f.read(1)
    r.unpack("C").first if r
  end
end
