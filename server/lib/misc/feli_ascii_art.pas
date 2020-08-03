unit feli_ascii_art;

{$mode objfpc}

interface
// uses ;

type
    FeliAsciiArt = class(TObject)
        public
            class function getCharFromRGBAverage(average: int64): ansiString; static;
            class function generate(filepath: ansiString; height: int64 = 64; width: int64 = 64): ansiString; static;
        end;

implementation
uses
    feli_stack_tracer,
    feli_constants,
    feli_logger,
    fpreadpng,
    fpimage,
    sysutils,
    fpcanvas,
    fpimgcanv;

class function FeliAsciiArt.getCharFromRGBAverage(average: int64): ansiString; static;
const 
    // denseChars = '$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?-_+~<>i!lI;:,"^`''. ';
    denseChars = '$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?-_+~<>i!lI;:,"^`''.  ';
    // denseChars = '$@B%yxz+=-  ';
var 
    denseCharsLength: int64;
    scalingFactor: real;
    selected: ansiString;
    selectedIndex: integer;
begin
    denseCharsLength := length(denseChars) - 1;
    scalingFactor := denseCharsLength/256;
    selected := ' ';
    try
        selectedIndex := Round(average * scalingFactor);
        selected := denseChars[selectedIndex + 1];
    except
      on E: Exception do
      begin
        selected := ' ';
      end;
    end;
    result := selected;
end;


class function FeliAsciiArt.generate(filepath: ansiString; height: int64 = 64; width: int64 = 64): ansiString; static;
var
    AWidth, AHeight: integer;
    image, resultImage: TFPCustomImage;
    reader: TFPCustomImageReader;
    canvas: TFPImageCanvas;
    i, j: integer;
    colours: TFPColor;
    meanRGB: int64;
    asciiArt: ansiString;
begin
    FeliStackTrace.trace('begin', 'function FeliAsciiArt.generate(filepath: ansiString): ansiString;');
    asciiArt := '';
    AWidth := width;
    AHeight := height;
    try
        image := TFPMemoryImage.create(0 ,0);
        reader := TFPReaderPNG.create();
        try
            image.LoadFromFile(filepath, reader);
        finally
        
        end;
        if (Image.Width / Image.Height) > (AWidth / AHeight) then
            AHeight := Round(AWidth / (Image.Width / Image.Height))
        else if (Image.Width / Image.Height) < (AWidth / AHeight) then
            AWidth := Round(AHeight * (Image.Width / Image.Height));

        resultImage := TFPMemoryImage.create(AWidth, AHeight);
        canvas := TFPImageCanvas.create(resultImage);
        try
            Canvas.StretchDraw(0, 0, AWidth, AHeight, Image);
            try
                for j := 0 to (resultImage.height - 1) do
                begin
                    for i := 0 to (resultImage.width - 1) do
                    begin
                        colours := resultImage.Colors[i, j];
                        meanRGB := Round((colours.Red + colours.Green + colours.Blue) / 3);
                        meanRGB := Round(meanRGB / 256);
                        asciiArt := asciiArt + FeliAsciiArt.getCharFromRGBAverage(meanRGB);
                    end;
                    asciiArt := asciiArt + lineSeparator;
                end;
            except
                on E: Exception do
                begin
                    FeliLogger.error(e.Message);
                end;
            end;

        finally
            Canvas.Free;
        end;
    finally
      
    end;
    result := asciiArt;
    FeliStackTrace.trace('end', 'function FeliAsciiArt.generate(filepath: ansiString): ansiString;');
end;



end.