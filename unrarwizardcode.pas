unit unrarwizardcode;

{
 This software was made by Popov Evgeniy Alekseyevich.
 It is distributed under the GNU GENERAL PUBLIC LICENSE (Version 2 or higher).
}

{$mode objfpc}
{$H+}

interface

uses Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls;

type

  { TMainWindow }

  TMainWindow = class(TForm)
    OpenButton: TButton;
    BrowseButton: TButton;
    ExtractButton: TButton;
    OverwriteCheckBox: TCheckBox;
    ArchiveField: TLabeledEdit;
    DirectoryField: TLabeledEdit;
    OpenDialog: TOpenDialog;
    SelectDirectoryDialog: TSelectDirectoryDialog;
    procedure OpenButtonClick(Sender: TObject);
    procedure BrowseButtonClick(Sender: TObject);
    procedure ExtractButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ArchiveFieldChange(Sender: TObject);
  private
    procedure window_setup();
    procedure dialog_setup();
    procedure interface_setup();
    procedure language_setup();
    procedure setup();
  public
    { public declarations }
  end; 

var MainWindow: TMainWindow;

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

function execute_program(const executable:string;const argument:string):Integer;
var code:Integer;
begin
 try
  code:=ExecuteProcess(executable,argument,[]);
 except
  code:=-1;
 end;
 execute_program:=code;
end;

procedure extract_data(const archive:string;const directory:string;const overwrite:boolean);
var target,work:string;
begin
 target:=ExtractFilePath(Application.ExeName)+'unrar.exe';
 work:='x ';
 if overwrite=true then work:='x -o+ ';
 if execute_program(target,work+convert_file_name(archive)+' '+convert_file_name(directory))<>0 then
 begin
  ShowMessage('Cannot extract the archive');
 end;

end;

procedure TMainWindow.window_setup();
begin
 Application.Title:='Unrar wizard';
 Self.Caption:='Unrar wizard 1.3.2';
 Self.BorderStyle:=bsDialog;
 Self.Font.Name:=Screen.MenuFont.Name;
 Self.Font.Size:=14;
end;

procedure TMainWindow.dialog_setup();
begin
 Self.SelectDirectoryDialog.InitialDir:='';
 Self.OpenDialog.InitialDir:='';
 Self.OpenDialog.FileName:='*.rar';
 Self.OpenDialog.DefaultExt:='*.rar';
 Self.OpenDialog.Filter:='Rar archive|*.rar';
end;

procedure TMainWindow.interface_setup();
begin
 Self.OpenButton.ShowHint:=False;
 Self.BrowseButton.ShowHint:=False;
 Self.BrowseButton.ShowHint:=False;
 Self.ExtractButton.Enabled:=False;
 Self.BrowseButton.Enabled:=False;
 Self.OverwriteCheckBox.Checked:=True;
 Self.ArchiveField.LabelPosition:=lpLeft;
 Self.DirectoryField.LabelPosition:=lpLeft;
 Self.ArchiveField.Enabled:=False;
 Self.DirectoryField.Enabled:=False;
 Self.ArchiveField.Text:='';
 Self.DirectoryField.Text:='';
end;

procedure TMainWindow.language_setup();
begin
 Self.ArchiveField.EditLabel.Caption:='Archive';
 Self.OverwriteCheckBox.Caption:='Overwrite the existing files';
 Self.OpenButton.Caption:='Open';
 Self.BrowseButton.Caption:='Browse';
 Self.ExtractButton.Caption:='Extract';
 Self.OpenDialog.Title:='Open the existing archive';
 Self.SelectDirectoryDialog.Title:='Please select the output directory';
end;

procedure TMainWindow.setup();
begin
 Self.window_setup();
 Self.dialog_setup();
 Self.interface_setup();
 Self.language_setup();
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 Self.setup();
end;

procedure TMainWindow.ArchiveFieldChange(Sender: TObject);
begin
 Self.ExtractButton.Enabled:=Self.ArchiveField.Text<>'';
 Self.BrowseButton.Enabled:=Self.ExtractButton.Enabled;
end;

procedure TMainWindow.OpenButtonClick(Sender: TObject);
begin
 if Self.OpenDialog.Execute()=True then
 begin
  Self.ArchiveField.Text:=Self.OpenDialog.FileName;
  Self.DirectoryField.Text:=ExtractFilePath(Self.OpenDialog.FileName);
 end;

end;

procedure TMainWindow.BrowseButtonClick(Sender: TObject);
begin
 if Self.SelectDirectoryDialog.Execute()=True then
 begin
  Self.DirectoryField.Text:=correct_path(Self.SelectDirectoryDialog.FileName);
 end;

end;

procedure TMainWindow.ExtractButtonClick(Sender: TObject);
begin
 extract_data(Self.ArchiveField.Text,Self.DirectoryField.Text,Self.OverwriteCheckBox.Checked);
end;

{$R *.lfm}

end.
