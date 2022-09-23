unit uAufgabe3MAIN;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, DB, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, DBGrids, math;                                                              //added math

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnStart: TButton;
    btnNextStep: TButton;
    DBsrc1: TDataSource;
    Image1: TImage;
    imgPos1: TImage;
    imgPos2: TImage;
    imgPos3: TImage;
    imgPos4: TImage;
    imgPos5: TImage;
    imgPos6: TImage;
    imgPos7: TImage;
    lblStrichadd: TLabel;
    lblStrichumleg: TLabel;
    lbledtHex1: TLabeledEdit;
    lbledtHex2: TLabeledEdit;
    SQLconHEX: TSQLite3Connection;
    SQLqryHEX: TSQLQuery;
    SQLtransHEX: TSQLTransaction;
    procedure btnNextStepClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure lbledtHex1Change(Sender: TObject);
    procedure lbledtHex2Change(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;
  i : integer;
  Strichsub : integer;
  Strichadd : integer;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.btnStartClick(Sender: TObject);            //vorarbeit : Bilder mit einzelnen Strichen angelegt und invisible gesetzt, damit diese nach Vorlage der DB true gesetzt werden können
begin
     if (lbledtHex1.Text <> '') or (lbledtHex2.text <> '')  THEN
     begin
     lblStrichadd.caption := '';            //lbls leeren und anderen knopf sichtbar machen, Start unsichtbar
     lblStrichumleg.caption := '';
     btnStart.visible := false;
     btnNextStep.visible := true;

     //verb. mit SQL-DB
     SQLconHEX.open;
     if SQLconHEX.connected then begin
       for i := 1 to 7 do            //jede einzelne Position durchgehen und mit Werten aus DB gleichsetzen
       begin
          //Wählt aus Ausgangseditfeld aus Datenbank boolean aus, welche Positionen der Striche sichtbar machen
          SQLqryHEX.SQL.Text := 'Select pos' + IntToStr(i) + ' from tblHexzahlen join tblBuchstabenHex on tblHexzahlen.idHex = tblBuchstabenHex.idHexBuch WHERE (Zahl = "' + lbledtHex1.Text + '");';
          SQLqryHEX.EXECSQL;
          SQLtransHEX.commit;
          SQLqryHEX.open;
          TImage(FindComponent('imgPos'+IntToStr(i))).visible := StrToBool( sqlqryHex.Fields[0].Asstring );       //Zeigt Anfangszahl als Bild an
       end;
       sqlqryHEX.close;
       SQLconHEX.close;
       i := 0;
     end;
                                    //Ausgangsbild erstellen mittels ON... true/false do ...
                                    //bools in 2 dbedts packen und vergleichen -- so lang bis etwas passiert, dann counter +1 bzw -1 und entsprechend das Bild ändern
                                    //Verschiebungen mittels AKTION:2 Variable, hinzufügen/wegnehmen von Strichen mittels Strichanzahl Ausgangszahl- Strichanzahl Endzahl
     Strichsub := 0;
     Strichadd := 0;
     end
     else                                                                                //check, ob alle Felder ausgefüllt sind
         Showmessage('Alle Felder müssen ausgefüllt sein - Bitte Eingaben überprüfen');
end;

//System zum Abfangen fehlerhafter Eingaben 1.Editfeld
procedure TfrmMain.lbledtHex1Change(Sender: TObject);
var
   zwischenlager : string;   //notwendig, da sonst Fehler in Datenfeld (char und str)
begin
     //prüft, ob nur eine Zahl eingegeben wurde
     if Length(lbledtHex1.text) > 1 THEN
     begin
          Showmessage('Vorsicht: Nur eine Hexadezimalzahl zugelassen!');
          zwischenlager :=  lbledtHex1.Text;
          Setlength(zwischenlager, Length(lbledtHex1.text)-1);;
          lbledtHex1.Text := zwischenlager;
     end;

     //prüft nach Kleinbuchstaben und ändert sie zu Großbuchstaben um
     if (Length (lbledtHex1.text) = 1) AND (lbledtHex1.text = LOWERCASE(lbledtHex1.text)) THEN
        lbledtHex1.text := UPPERCASE(lbledtHex1.text);

     //prüft, ob eingegebene Zahl eine Hexadezimalzahl ist
     if (Length (lbledtHex1.text) = 1) AND not (char(lbledtHex1.text[length(lbledtHex1.text)]) in ['0'..'9']) and not (char(lbledtHex1.text[length(lbledtHex1.text)]) in ['A'..'F']) THEN
     begin
          Showmessage('Vorsicht: Nur Hexadezimalzahlen (1...9, A...F) zugelassen');
          zwischenlager :=  lbledtHex1.Text;
          Setlength(zwischenlager, Length(lbledtHex1.text)-1);;
          lbledtHex1.Text := zwischenlager;
     end;

end;
//System zum Abfangen fehlerhafter Eingaben 2.Editfeld
procedure TfrmMain.lbledtHex2Change(Sender: TObject);
var
   zwischenlager : string;
begin
     //prüft, ob nur eine Zahl eingegeben wurde
     if Length(lbledtHex2.text) > 1 THEN
     begin
          Showmessage('Vorsicht: Nur eine Hexadezimalzahl zugelassen!');
          zwischenlager :=  lbledtHex2.Text;
          Setlength(zwischenlager, Length(lbledtHex2.text)-1);;
          lbledtHex2.Text := zwischenlager;
     end;

     //prüft nach Kleinbuchstaben und ändert sie zu Großbuchstaben um
     if (Length (lbledtHex2.text) = 1) AND (lbledtHex2.text = LOWERCASE(lbledtHex2.text)) THEN
        lbledtHex2.text := UPPERCASE(lbledtHex2.text);

     //prüft, ob eingegebene Zahl eine Hexadezimalzahl ist
     // (vgl.)Quelle: https://forum.lazarus.freepascal.org/index.php?topic=10351.15
     if (Length (lbledtHex2.text) = 1) AND not (char(lbledtHex2.text[length(lbledtHex2.text)]) in ['0'..'9']) and not (char(lbledtHex2.text[length(lbledtHex2.text)]) in ['A'..'F']) THEN
     begin
          Showmessage('Vorsicht: Nur Hexadezimalzahlen (1...9, A...F) zugelassen');
          zwischenlager :=  lbledtHex2.Text;
          Setlength(zwischenlager, Length(lbledtHex2.text)-1);;
          lbledtHex2.Text := zwischenlager;
     end;
end;


procedure TfrmMain.btnNextStepClick(Sender: TObject);
var
   move : boolean;
   Strichdiff : integer;
   AnzStrich1 : integer;
   AnzStrich2 : integer;
begin
  move := false;
  SQLconHEX.open;
  //gleicht bestehende Positionen mit DB ab und ändert wenn nötig Zustand des Striches
  if SQLconHEX.connected then begin
      repeat
         i := i +1;
         SQLqryHEX.SQL.Text := 'Select pos' + IntToStr(i) + ' from tblHexzahlen join tblBuchstabenHex on tblHexzahlen.idHex = tblBuchstabenHex.idHexBuch WHERE (Zahl = "' + lbledtHex2.Text + '");';
         SQLqryHEX.EXECSQL;
         SQLtransHEX.commit;
         SQLqryHEX.open;
         if TImage(FindComponent('imgPos'+IntToStr(i))).visible <> StrToBool( sqlqryHex.Fields[0].Asstring ) THEN
         begin
              Case TImage(FindComponent('imgPos'+IntToStr(i))).visible of
                   True: strichsub := strichsub +1;
                   False:    strichadd := strichadd +1;
              end;
              TImage(FindComponent('imgPos'+IntToStr(i))).visible := StrToBool( sqlqryHex.Fields[0].Asstring );
              move := true;
         end;
      sqlqryHEX.close;
      if i = 7 THEN break; //notwendig, um zu verhindern, dass Prozedur außerhalb des Wertebereiches ist (i>7)
      until move = True;
  end;

  //berechnet Umlegungen und zu hinzufügende/wegzunehmende Striche mit vermerkter Anzahl des Striche aus DB
  if i = 7 THEN
  begin
       btnNextStep.visible := false;
       btnStart.visible := True;
       SQLqryHEX.SQL.Text := 'Select StrichAnzahl from tblHexzahlen join tblBuchstabenHex on tblHexzahlen.idHex = tblBuchstabenHex.idHexBuch WHERE (Zahl = "' + lbledtHex1.Text + '");';
       SQLtransHEX.commit;
       SQLqryHEX.open;
       AnzStrich1 := sqlqryHex.Fields[0].AsInteger;
       SQLqryHEX.close;
       SQLqryHEX.SQL.Text := 'Select StrichAnzahl from tblHexzahlen join tblBuchstabenHex on tblHexzahlen.idHex = tblBuchstabenHex.idHexBuch WHERE (Zahl = "' + lbledtHex2.Text + '");';
       SQLqryHEX.EXECSQL;
       SQLtransHEX.commit;
       SQLqryHEX.open;
       AnzStrich2 := sqlqryHex.Fields[0].AsInteger;
       Strichdiff := AnzStrich1 - AnzStrich2;
       if Strichdiff < 0 THEN begin                            //schaut auf Differenz von Strichanzahl, daraus abzuleiten, ob Striche hinzufügen oder wegnehmen
          Strichdiff := Strichdiff * -1;                                           //Differenz ist Anzahl an hinzuzufügenden/wegzunehmenden Strichen
          lblStrichadd.caption := 'Hinzuzufügende Striche: ' + IntToStr(Strichdiff);
       end
       else
       begin
          lblStrichadd.caption := 'Wegzunehmende Striche: ' + IntToStr(Strichdiff);
       end;
       //berechnet Umlegungen
       if (Strichadd = 0) OR (Strichsub = 0) THEN //wenn eines der beiden 0, dann wird nur hinzugefügt/weggenommen
          lblStrichumleg.Caption := 'Umlegungen: 0'
       else    //Umlegungen --> ergibt sich aus minimum der hinzuzufügenden/wegzunehmenden Strichen
          lblStrichumleg.Caption := 'Umlegungen: ' + IntToStr(min(Strichadd,Strichsub));

  end;
end;
end.

