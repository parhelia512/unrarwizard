unit unrarwizardcode;

{$mode objfpc}{$H+}

interface

uses
Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls, LazFileUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var Form1: TForm1;

implementation

function convert_file_name(const source:string): string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"'+source+'"';
 end;
 convert_file_name:=target;
end;

function correct_path(const source:string ): string;
var target:string;
begin
 target:=source;
 if LastDelimiter(DirectorySeparator,source)<>Length(source) then
 begin
  target:=source+DirectorySeparator;
 end;
 correct_path:=target;
end;

procedure execute_program(const executable:string;const argument:string);
begin
 try
  ExecuteProcess(executable,argument,[]);
 except
  ShowMessage('Cant run an external program');
 end;

end;

procedure extract_data(const archive:string;const directory:string;const overwrite:boolean);
var target,work:string;
begin
 target:=ExtractFilePath(Application.ExeName)+'unrar.exe';
 work:='x ';
 if overwrite=true then work:='x -o+ ';
 execute_program(target,work+convert_file_name(archive)+' '+convert_file_name(directory));
end;

procedure window_setup();
begin
 Application.Title:='Unrar wizard';
 Form1.Caption:='Unrar wizard 1.2.6';
 Form1.BorderStyle:=bsDialog;
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
end;

procedure dialog_setup();
begin
 Form1.SelectDirectoryDialog1.InitialDir:='';
 Form1.OpenDialog1.InitialDir:='';
 Form1.OpenDialog1.FileName:='*.rar';
 Form1.OpenDialog1.DefaultExt:='*.rar';
 Form1.OpenDialog1.Filter:='Rar archive|*.rar';
end;

procedure interface_setup();
begin
 Form1.Button1.ShowHint:=False;
 Form1.Button2.ShowHint:=False;
 Form1.Button2.ShowHint:=False;
 Form1.Button3.Enabled:=False;
 Form1.CheckBox1.Checked:=True;
 Form1.LabeledEdit1.LabelPosition:=lpLeft;
 Form1.LabeledEdit2.LabelPosition:=lpLeft;
 Form1.LabeledEdit1.Enabled:=False;
 Form1.LabeledEdit2.Enabled:=False;
 Form1.LabeledEdit1.Text:='';
 Form1.LabeledEdit2.Text:='';
end;

procedure language_setup();
begin
 Form1.LabeledEdit1.EditLabel.Caption:='Archive';
 Form1.CheckBox1.Caption:='Overwrite the existing files';
 Form1.Button1.Caption:='Open';
 Form1.Button2.Caption:='Browse';
 Form1.Button3.Caption:='Extract';
 Form1.OpenDialog1.Title:='Open the existing archive';
 Form1.SelectDirectoryDialog1.Title:='Please select the output directory';
end;

procedure setup();
begin
 window_setup();
 dialog_setup();
 interface_setup();
 language_setup();
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
 Form1.Button3.Enabled:=Form1.LabeledEdit1.Text<>'';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if Form1.OpenDialog1.Execute()=True then
 begin
  Form1.LabeledEdit1.Text:=Form1.OpenDialog1.FileName;
  Form1.LabeledEdit2.Text:=ExtractFilePath(Form1.OpenDialog1.FileName);
 end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 if Form1.SelectDirectoryDialog1.Execute()=True then
 begin
  Form1.LabeledEdit2.Text:=correct_path(Form1.SelectDirectoryDialog1.FileName);
 end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 extract_data(Form1.LabeledEdit1.Text,Form1.LabeledEdit2.Text,Form1.CheckBox1.Checked);
end;

{$R *.lfm}

end.
