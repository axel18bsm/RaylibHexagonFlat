program hexagongridflattop;

{$mode objfpc}{$H+}

uses
  raylib,
  math,SysUtils,initvariable,BoutonClic;

//const
  //gridWidth = 8;                // Nombre de colonnes
  //gridHeight = 10;               // Nombre de lignes
  //hexRadius = 30;                // Rayon de chaque hexagone
  //hexWidth = 2 * hexRadius;      // Largeur de l'hexagone (tête plate)
  //hexHeight = sqrt(3) * hexRadius;  // Hauteur de l'hexagone (distance verticale entre deux points)
  //windowWidth = 1024;
  //windowHeight = 600;

//type
//  THexagon = record
//    X, Y: Integer;              // Position du centre de l'hexagone
//    Number: Integer;            // Numéro unique de l'hexagone
//  end;

var
   //HexGrid: array[1..TotalNbreHex] of THexCell;
  i: Integer;  // Variable de boucle




  function PairOuImpairCol(Number: Integer):boolean;
begin
  if not(Number mod 2 = 0) then
    PairOuImpairCol:=true // impair
  else
    PairOuImpaircol:=false;
end;
 function ColorToString(Color: TColor): string;
begin
  Result := Format('%d,%d,%d', [Color.r, Color.g, Color.b]);
end;

// Fonction pour convertir TEmplacement en chaîne de caractères
function EmplacementToString(Emplacement: TEmplacement): string;
begin
  case Emplacement of
    inconnu: Result := 'inconnu';
    CoinHG: Result := 'CoinHG';
    CoinHD: Result := 'CoinHD';
    CoinBG: Result := 'CoinBG';
    CoinBD: Result := 'CoinBD';
    BordH: Result := 'BordH';
    BordB: Result := 'BordB';
    BordG: Result := 'BordG';
    BordD: Result := 'BordD';
    Classic: Result := 'Classic';
  end;
end;
procedure SaveHexGridToCSV();
  var
    F: TextFile;
    i, k: Integer;
    NeighborStr, VerticesStr: string;
  begin
    AssignFile(F, SaveFileName);
    Rewrite(F);
    try
      // Ecrire l'en-tête du CSV
      Writeln(F, 'Number,CenterX,CenterY,ColorR,ColorG,ColorB,Selected,Colonne,Ligne,Emplacement,PairImpairLigne,' +
                 'Vertex1X,Vertex1Y,Vertex2X,Vertex2Y,Vertex3X,Vertex3Y,Vertex4X,Vertex4Y,Vertex5X,Vertex5Y,Vertex6X,Vertex6Y,' +
                 'Neighbor1,Neighbor2,Neighbor3,Neighbor4,Neighbor5,Neighbor6');

      for i := 1 to TotalNbreHex do
      begin
        // Sauvegarder les voisins comme une chaîne séparée par des virgules
        NeighborStr := Format('%d,%d,%d,%d,%d,%d', [HexGrid[i].Neighbors[1], HexGrid[i].Neighbors[2],
                                                    HexGrid[i].Neighbors[3], HexGrid[i].Neighbors[4],
                                                    HexGrid[i].Neighbors[5], HexGrid[i].Neighbors[6]]);

        // Sauvegarder les vertices comme une chaîne séparée par des virgules
        VerticesStr := '';
        for k := 0 to 5 do
        begin
          VerticesStr := VerticesStr + Format('%d,%d', [HexGrid[i].Vertices[k].x, HexGrid[i].Vertices[k].y]);
          if k < 5 then
            VerticesStr := VerticesStr + ',';  // Ajouter une virgule sauf après le dernier point
        end;

        // Sauvegarder toutes les informations de l'hexagone
        Writeln(F, Format('%d,%.0f,%.0f,%d,%d,%d,%s,%d,%d,%s,%s,%s,%s',                   //%d,%d, // HexGrid[i].Center.x, HexGrid[i].Center.y,
          [HexGrid[i].Number,
           HexGrid[i].Center.x, HexGrid[i].Center.y,
           HexGrid[i].Color.r, HexGrid[i].Color.g, HexGrid[i].Color.b,
           BoolToStr(HexGrid[i].Selected, True),
           HexGrid[i].Colonne, HexGrid[i].Ligne,
           EmplacementToString(HexGrid[i].Poshexagone),
           BoolToStr(HexGrid[i].PairImpairLigne, True),
           VerticesStr,  // Ajout des vertices
           NeighborStr]));
      end;
    finally
      CloseFile(F);
    end;
  end;

procedure TrouveLesVoisins();
//TEmplacement = (inconnu, CoinHG, CoinHD, CoinBG, CoinBD, BordH, BordB,BordG,BordD,Classic);

begin

        If CoinIn =False Then                                                    // separation pour etre plus lisible
        begin
           for I := 1 to TotalNbreHex  do
           begin
                case HexGrid[i].Poshexagone of
                 inconnu:
                   begin
                     for j := 1 to 6 do
                     begin
                       HexGrid[i].Neighbors[j]:=0;                              //hexagone inconnu donc pas de voisin
                     end;
                   end;
                 CoinHG:
                   begin                                                        // toujours ligne impaire
                     HexGrid[i].Neighbors[1]:=0;
                     HexGrid[i].Neighbors[2]:=0;
                     HexGrid[i].Neighbors[3]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                     HexGrid[i].Neighbors[5]:=0;
                     HexGrid[i].Neighbors[6]:=0;
                   end;
                 Coinbg:
                      begin
                     HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;
                     HexGrid[i].Neighbors[2]:=HexGrid[i].Number-columns+1;
                     HexGrid[i].Neighbors[3]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[4]:=0;
                     HexGrid[i].Neighbors[5]:=0;
                     HexGrid[i].Neighbors[6]:=0;
                     end;
                 CoinHD:                                                        // toujours ligne impaire
                   begin
                     if HexGrid[i].PairImpaircolonne=false then
                   begin
                     HexGrid[i].Neighbors[1]:=0;                                //paire colonne
                     HexGrid[i].Neighbors[2]:=0;
                     HexGrid[i].Neighbors[3]:=0;
                     HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                     HexGrid[i].Neighbors[5]:=HexGrid[i].Number+columns-1;
                     HexGrid[i].Neighbors[6]:=HexGrid[i].Number-1;
                   end
                   else
                   begin
                     HexGrid[i].Neighbors[1]:=0;      //pair
                     HexGrid[i].Neighbors[2]:=0;
                     HexGrid[i].Neighbors[3]:=0;
                     HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                     HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1;
                     HexGrid[i].Neighbors[6]:=0;
                   end;
                   End;

                 Coinbd:
                  if HexGrid[i].PairImpaircolonne=false then                      //ligne paire
                   begin
                     HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;
                     HexGrid[i].Neighbors[2]:=0;
                     HexGrid[i].Neighbors[3]:=0;
                     HexGrid[i].Neighbors[4]:=0;
                     HexGrid[i].Neighbors[5]:=0;
                     HexGrid[i].Neighbors[6]:=HexGrid[i].Number-1;
                   end
                   else
                   begin
                     HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;                                 //impair
                     HexGrid[i].Neighbors[2]:=0;
                     HexGrid[i].Neighbors[3]:=0;
                     HexGrid[i].Neighbors[4]:=0;
                     HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1;
                     HexGrid[i].Neighbors[6]:=HexGrid[i].Number-columns-1;
                   end;
                 BordH:                                                         //toujours impair
                 if HexGrid[i].PairImpaircolonne=false then                      //ligne paire
                   begin
                     HexGrid[i].Neighbors[1]:=0;
                     HexGrid[i].Neighbors[2]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[3]:=HexGrid[i].Number+columns+1;
                     HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                     HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1+columns;
                     HexGrid[i].Neighbors[6]:=HexGrid[i].Number-1;
                   end
                   else
                   begin
                     HexGrid[i].Neighbors[1]:=0;                                 //impair
                     HexGrid[i].Neighbors[2]:=0;
                     HexGrid[i].Neighbors[3]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                     HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1;
                     HexGrid[i].Neighbors[6]:=0;
                   end;
                 BordB:
                 if HexGrid[i].PairImpaircolonne=false then                        //ligne impaire
                 begin
                     HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;
                     HexGrid[i].Neighbors[2]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[3]:=0;
                     HexGrid[i].Neighbors[4]:=0;
                     HexGrid[i].Neighbors[5]:=0;
                     HexGrid[i].Neighbors[6]:=HexGrid[i].Number-1;
                   end
                   else
                   begin
                     HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;      //ligne paire
                     HexGrid[i].Neighbors[2]:=HexGrid[i].Number-columns+1;
                     HexGrid[i].Neighbors[3]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[4]:=0;
                     HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1;
                     HexGrid[i].Neighbors[6]:=HexGrid[i].Number-columns-1;
                   end;
                 BordG:
                 begin
                                                                            // toujours ligne impaire
                     HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;
                     HexGrid[i].Neighbors[2]:=HexGrid[i].Number-columns+1;
                     HexGrid[i].Neighbors[3]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                     HexGrid[i].Neighbors[5]:=0;
                     HexGrid[i].Neighbors[6]:=0;
                   end;

                 BordD:
                     begin
                    if HexGrid[i].PairImpaircolonne=false then                    //ligne impaire
                    begin
                    HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;
                    HexGrid[i].Neighbors[2]:=0;
                    HexGrid[i].Neighbors[3]:=0;
                    HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                    HexGrid[i].Neighbors[5]:=HexGrid[i].Number+columns-1;
                    HexGrid[i].Neighbors[6]:=HexGrid[i].Number-1;
                    end
                    else
                    begin
                    HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;                                 //ligne paire
                    HexGrid[i].Neighbors[2]:=0;
                    HexGrid[i].Neighbors[3]:=0;
                    HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                    HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1;
                    HexGrid[i].Neighbors[6]:=HexGrid[i].Number-columns-1;
                    end;
                    end;
                     Classic:
                     begin
                    if HexGrid[i].PairImpaircolonne=false then                    //ligne impaire
                    begin
                    HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;
                    HexGrid[i].Neighbors[2]:=HexGrid[i].Number+1;
                    HexGrid[i].Neighbors[3]:=HexGrid[i].Number+columns+1;
                    HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                    HexGrid[i].Neighbors[5]:=HexGrid[i].Number+columns-1;
                    HexGrid[i].Neighbors[6]:=HexGrid[i].Number-1;
                    end
                    else
                    begin
                    HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;       //ligne paire
                    HexGrid[i].Neighbors[2]:=HexGrid[i].Number-columns+1;
                    HexGrid[i].Neighbors[3]:=HexGrid[i].Number+1;
                    HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                    HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1;
                    HexGrid[i].Neighbors[6]:=HexGrid[i].Number-columns-1;
                    end;
                    end;
                   end;
                end;
           end;



        If CoinIn =True Then
        begin
           for I := 1 to TotalNbreHex  do
           begin
                case HexGrid[i].Poshexagone of
                 inconnu:
                   begin
                     for j := 1 to 6 do
                     begin
                       HexGrid[i].Neighbors[j]:=0;                              //hexagone inconnu donc pas de voisin
                     end;
                   end;
                 CoinHG:
                   begin                                                        // toujours ligne impaire
                     HexGrid[i].Neighbors[1]:=0;
                     HexGrid[i].Neighbors[2]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[3]:=HexGrid[i].Number+columns+1;
                     HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                     HexGrid[i].Neighbors[5]:=0;
                     HexGrid[i].Neighbors[6]:=0;
                   end;
                 Coinbg:
                      begin
                     HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;
                     HexGrid[i].Neighbors[2]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[3]:=0;
                     HexGrid[i].Neighbors[4]:=0;
                     HexGrid[i].Neighbors[5]:=0;
                     HexGrid[i].Neighbors[6]:=0;
                     end;
                 CoinHD:                                                        // toujours ligne impaire
                   begin
                     if HexGrid[i].PairImpaircolonne=false then
                   begin
                     HexGrid[i].Neighbors[1]:=0;                                //paire colonne
                     HexGrid[i].Neighbors[2]:=0;
                     HexGrid[i].Neighbors[3]:=0;
                     HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                     HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1;
                     HexGrid[i].Neighbors[6]:=0;
                   end
                   else
                   begin
                     HexGrid[i].Neighbors[1]:=0;      //pair
                     HexGrid[i].Neighbors[2]:=0;
                     HexGrid[i].Neighbors[3]:=0;
                     HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                     HexGrid[i].Neighbors[5]:=HexGrid[i].Number+columns-1;
                     HexGrid[i].Neighbors[6]:=HexGrid[i].Number-1;
                   end;
                   End;

                 Coinbd:
                  if HexGrid[i].PairImpaircolonne=false then                      //ligne paire
                   begin
                     HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;
                     HexGrid[i].Neighbors[2]:=0;
                     HexGrid[i].Neighbors[3]:=0;
                     HexGrid[i].Neighbors[4]:=0;
                     HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1;
                     HexGrid[i].Neighbors[6]:=HexGrid[i].Number-columns-1;
                   end
                   else
                   begin
                     HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;                                 //impair
                     HexGrid[i].Neighbors[2]:=0;
                     HexGrid[i].Neighbors[3]:=0;
                     HexGrid[i].Neighbors[4]:=0;
                     HexGrid[i].Neighbors[5]:=0;
                     HexGrid[i].Neighbors[6]:=HexGrid[i].Number-1;
                   end;
                 BordH:                                                         //toujours impair
                 if HexGrid[i].PairImpaircolonne=false then                      //ligne paire
                   begin
                     HexGrid[i].Neighbors[1]:=0;
                     HexGrid[i].Neighbors[2]:=0;
                     HexGrid[i].Neighbors[3]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                     HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1;
                     HexGrid[i].Neighbors[6]:=0;
                   end
                   else
                   begin
                     HexGrid[i].Neighbors[1]:=0;                                 //impair
                     HexGrid[i].Neighbors[2]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[3]:=HexGrid[i].Number+columns+1;
                     HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                     HexGrid[i].Neighbors[5]:=HexGrid[i].Number+columns-1;
                     HexGrid[i].Neighbors[6]:=HexGrid[i].Number-1;
                   end;
                 BordB:
                 if HexGrid[i].PairImpaircolonne=false then                        //ligne impaire
                 begin
                     HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;
                     HexGrid[i].Neighbors[2]:=HexGrid[i].Number-columns+1;
                     HexGrid[i].Neighbors[3]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[4]:=0;
                     HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1;
                     HexGrid[i].Neighbors[6]:=HexGrid[i].Number-columns-1;
                   end
                   else
                   begin
                     HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;      //ligne paire
                     HexGrid[i].Neighbors[2]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[3]:=0;
                     HexGrid[i].Neighbors[4]:=0;
                     HexGrid[i].Neighbors[5]:=0;
                     HexGrid[i].Neighbors[6]:=HexGrid[i].Number-1;
                   end;
                 BordG:
                 begin
                                                                            // toujours ligne impaire
                     HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;
                     HexGrid[i].Neighbors[2]:=HexGrid[i].Number+1;
                     HexGrid[i].Neighbors[3]:=HexGrid[i].Number+columns+1;
                     HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                     HexGrid[i].Neighbors[5]:=0;
                     HexGrid[i].Neighbors[6]:=0;
                   end;

                 BordD:
                     begin
                    if HexGrid[i].PairImpaircolonne=false then                    //ligne impaire
                    begin
                    HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;
                    HexGrid[i].Neighbors[2]:=0;
                    HexGrid[i].Neighbors[3]:=0;
                    HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                    HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1;
                    HexGrid[i].Neighbors[6]:=HexGrid[i].Number-columns-1;
                    end
                    else
                    begin
                    HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;                                 //ligne paire
                    HexGrid[i].Neighbors[2]:=0;
                    HexGrid[i].Neighbors[3]:=0;
                    HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                    HexGrid[i].Neighbors[5]:=HexGrid[i].number+columns-1;
                    HexGrid[i].Neighbors[6]:=HexGrid[i].Number-1;
                    end;
                    end;
                     Classic:
                     begin
                    if HexGrid[i].PairImpaircolonne=false then                    //ligne impaire
                    begin
                    HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;
                    HexGrid[i].Neighbors[2]:=HexGrid[i].Number-columns+1;
                    HexGrid[i].Neighbors[3]:=HexGrid[i].Number+1;
                    HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                    HexGrid[i].Neighbors[5]:=HexGrid[i].Number-1;
                    HexGrid[i].Neighbors[6]:=HexGrid[i].Number-columns-1;
                    end
                    else
                    begin
                    HexGrid[i].Neighbors[1]:=HexGrid[i].Number-columns;       //ligne paire
                    HexGrid[i].Neighbors[2]:=HexGrid[i].Number+1;
                    HexGrid[i].Neighbors[3]:=HexGrid[i].Number+columns+1;
                    HexGrid[i].Neighbors[4]:=HexGrid[i].Number+columns;
                    HexGrid[i].Neighbors[5]:=HexGrid[i].Number+columns-1;
                    HexGrid[i].Neighbors[6]:=HexGrid[i].Number-1;
                    end;
                    end;
                   end;
                end;
           end;
end;

procedure PositionHexagone();

 begin
   for I := 1 to TotalNbreHex do HexGrid[i].Poshexagone:=inconnu;       //initialisation de tous les  champs à inconnu(0)

   for I := 1 to totalnbrehex do
   begin
     if HexGrid[i].Colonne=1 then HexGrid[i].Poshexagone:=BordG;           //bord gauche car 1ere colonne
     if HexGrid[i].ligne=1 then HexGrid[i].Poshexagone:=BordH;             //bordhaut  car 1ere ligne
     if HexGrid[i].colonne=columns then HexGrid[i].Poshexagone:=BordD;     //borddroit car derniere clonne
     if HexGrid[i].ligne=rows then HexGrid[i].Poshexagone:=Bordb;        //bordbas derniere ligne car on le connait à l initialisation
   end;

   // les coins                                                                //on ecrase les coins
     HexGrid[1].Poshexagone:=CoinHG;                                    // le 1 c'est haut gauche
     HexGrid[TotalNbreHex].Poshexagone:=CoinBD;                         // le dernier, c'est bas droit.
     HexGrid[columns].Poshexagone:=CoinHD;                              // coin haut droit
     HexGrid[TotalNbreHex-columns+1].Poshexagone:=CoinBG;                // coin bas gauche

   // lereste des inconnus sont des classic
      for I := 1 to totalnbrehex do
   begin
     if HexGrid[i].Poshexagone=inconnu then HexGrid[i].Poshexagone:=classic;           //inconnu en classic
     end;
End;
procedure CalculateNeighbors();
begin
   //' il faut trouver les lignes pairs et impairs, c'est fait dans l initialisation
   //' il faut caler les types d emplacement
         PositionHexagone();
   //' il faut ensuite  positionner les voisins.les voisins, c est un mixte quelle ligne et de coinIn
   // qui vont determiner les voisins d'un autre pour les tetes pointues pour les tetes plates c'est
   // encore different
         TrouveLesVoisins();
end;


// Fonction pour dessiner un hexagone à partir de son centre (X, Y)
//si il n y pas une fonction pour tracer des polygones. tete plate
procedure DrawHexagon2(hex: THexCell);
var
  i: Integer;
  angle: Float;
  point1, point2: TVector2;

begin
  for i := 0 to 5 do
  begin
    // Calculer les vertices de l'hexagone en utilisant l'angle (hexagone tête plate)
    angle := Pi / 3 * i; // Angle = 60° entre chaque sommet,
    point1.x := hex.Center.X + Round(cos(angle) * hexRadius);
    point1.y := hex.center.Y + Round(sin(angle) * hexRadius);
    point2.x := hex.center.X + Round(cos(angle + Pi / 3) * hexRadius);
    point2.y := hex.center.Y + Round(sin(angle + Pi / 3) * hexRadius);

    // Dessiner les côtés de l'hexagone
    DrawLineV(point1, point2, DARKGRAY);
  end;

  // Afficher le numéro de l'hexagone au centre
  DrawText(PChar(IntToStr(hex.Number)), round(hex.center.X) - 10, round(hex.center.Y) - 10, 20, BLACK);
end;
procedure DrawHexGrid(dessineLesNombres:boolean);
  var
   hexNumberText: array[0..5] of char;
   outlineColor: TColor;

  begin

    for i := 1 to TotalNbreHex do                                                // numéro de l hexagone

      begin
        DrawPoly(Vector2Create(HexGrid[i].Center.x, HexGrid[i].Center.y ),       //on pourrait ameliorer le code en remplacant les
          6, HexRadius - 1, 60, HexGrid[i].Color);                               //tpoints en tvector2. Pascal est strict.

        if HexGrid[i].Selected then
          outlineColor := ORANGE
        else
          outlineColor := DARKGRAY;

        DrawPolyLinesEx(Vector2Create(HexGrid[I].Center.x, HexGrid[I].Center.y),
          6, HexRadius, 60, 2, outlineColor);
       if dessineLesNombres=True then
         begin
        StrPCopy(hexNumberText, IntToStr(HexGrid[I].Number));
        DrawText(hexNumberText, Round(HexGrid[I].Center.x - 10),Round(HexGrid[I].Center.y - 10), 20, BLACK);
         End;
         end;
      end;
procedure CalculateHexVertices(var Hex: THexCell);
// permet de creer un hexagon.
  var
    angle_deg, angle_rad: single;
    k: integer;
  begin
    for k := 0 to 5 do
    begin
      angle_deg := 30 + 60 * k;  // Angle de rotation pour un hexagone "tête pointue"
      angle_rad := PI / 180 * angle_deg;
      Hex.Vertices[k].x := Round(Hex.Center.x + HexRadius * cos(angle_rad));
      Hex.Vertices[k].y := Round(Hex.Center.y + HexRadius * sin(angle_rad));
    end;
  end;


// Procédure pour générer la grille d'hexagones
procedure GenerateHexagons;
var
  x, y, i: Integer;
  offsetX, offsetY: Single;
begin
  i := 1;
  for y := 1 to rows  do
  begin
    for x := 1 to columns  do
    begin
      // Calcul de la position horizontale de chaque hexagone
      offsetX :=50+ x * (hexWidth * 0.75); // Décalage horizontal avec 75% de la largeur

      // Décalage vertical pour aligner les lignes paires et impaires
      offsetY :=50+ y * (hexHeight);

      // Si la ligne est impaire, on ajoute un décalage à gauche
      if (x mod 2) = 1 then
        begin
           if CoinIn=true then
             begin
             offsetY := offsetY + (hexHeight / 2)

             end
           else
               begin
              offsetY := offsetY - (hexHeight / 2)
             end;
        end;

        HexGrid[i].Number := i;                                 // onstocke le numero de l hexagone
        HexGrid[i].colonne := x;   //colonne                            // son numero de colonne
        HexGrid[i].ligne := y;    //rows                                //son numero de ligne
        HexGrid[i].PairImpaircolonne:=PairOuImpairCol(HexGrid[i].Colonne);

      // Enregistrer la position centrale de l'hexagone
      HexGrid[i].center.X := Round(offsetX + hexRadius);
      HexGrid[i].center.Y := Round(offsetY + hexHeight / 2);
      if (x + y) mod 2 = 0 then
        begin                                                                   // permet de mettre une couleur en decalage
          HexGrid[i].Color := GREEN;
        end
        else
        begin
          HexGrid[i].Color := LIGHTGRAY;
        End;

        HexGrid[i].Selected := False;                                   // toujours à faux au demarrage, personne n a cliqué


        CalculateHexVertices(HexGrid[i]);                               // Calcule les sommets de l'hexagone

      Inc(i);


    end;
  end;
end;
procedure DrawHexInfoBox();
  var
    InfoText: string;
    hexrowsText:PChar;
  begin
    DrawRectangle(0, WindowHeight - InfoBoxHeight, WindowWidth, InfoBoxHeight, LIGHTGRAY);
    // Cadre de fond
    DrawRectangleLines(0, WindowHeight - InfoBoxHeight, WindowWidth,
      InfoBoxHeight, DARKGRAY); // Contour
     // affiche le boutton de sauvegaarde:
     DrawRectangleRec(Buttonsave.Rect, ColorToUse);
     DrawText('Sauve la grille', Round(Buttonsave.Rect.x+25), Round(Buttonsave.Rect.y + 15), 20, BLACK);
     // DrawRectangleRec(ButtonRowsP.Rect, ColorToUse);
     // DrawText('+', Round(ButtonRowsP.Rect.x+5), Round(ButtonRowsP.Rect.y + 1), 20, BLACK);
     // DrawRectangleRec(ButtonRowsM.Rect, ColorToUse);
     //DrawText('-', Round(ButtonRowsM.Rect.x+5), Round(ButtonRowsM.Rect.y + 1), 20, BLACK);
      DrawRectangle(510, 10, 30, 20, LIGHTGRAY);
      DrawText('Rows.', 511, 13, 12, BLACK);
      DrawRectangle(575, 10, 30, 20, LIGHTGRAY);
      //StrPCopy(hexrowsText, IntToStr(rows));
      DrawText(PChar(IntToStr(columns)), 576,13 , 14, BLACK);
    if HexSelected then
    begin
      InfoText := Format('Numéro de l''hexagone: %d'#10 +
        'Point Central: (%.0f, %.0f)'#10 +
        'Couleur: %s'#10 +
        'Voisins: %d, %d, %d, %d, %d, %d'#10 +
        'ligne : %d' + ' colonne : %d'#10+
        'Position : %d',
        [SelectedHex.Number, SelectedHex.Center.x,
        SelectedHex.Center.y, 'Vert',
        SelectedHex.Neighbors[1], SelectedHex.Neighbors[2],
        SelectedHex.Neighbors[3], SelectedHex.Neighbors[4],
        SelectedHex.Neighbors[5], SelectedHex.Neighbors[6], SelectedHex.ligne,
        SelectedHex.Colonne,SelectedHex.Poshexagone]);
      DrawText(PChar(InfoText), 20, WindowHeight - InfoBoxHeight + 20, 20, BLACK);
    end
    else
      DrawText('Aucun hexagone sélectionné.', 20, WindowHeight -
        InfoBoxHeight + 20, 20, BLACK);
  end;

// Gère la détection de clic sur un hexagone et met à jour les informations
 procedure HandleMouseClick();
 var
   mouseX, mouseY: integer;
   dx, dy: single;
   dist: single;

 begin
   if IsMouseButtonPressed(MOUSE_LEFT_BUTTON) then
   begin
     mouseX := GetMouseX();
     mouseY := GetMouseY();
     HexSelected := False;
     MousePosition:=Vector2Create(mouseX,mouseY);
     for i := 1 to TotalNbreHex do

       begin
         dx := mouseX - HexGrid[i].Center.x;
         dy := mouseY - HexGrid[i].Center.y;
         dist := sqrt(dx * dx + dy * dy);
         if dist <= HexRadius-decalageRayon then  //diminution du rayon entre -1 et -2 pour ne pas cliquer sur 2 hexagones joints
         begin                                    // plus le rayon est long, plus le decalage doit etre important.
           HexGrid[i].Selected := True;
           SelectedHex := HexGrid[i];
           HexSelected := True;
         end
         else
           HexGrid[i].Selected := False;
       end;
     // bouton normaux
     { #todo : inserer un bouton pour sauvegarder }
        if CheckCollisionPointRec(MousePosition, ButtonSave.Rect) then
        begin
         ButtonSave.IsClicked := True;
      { #todo : appeler la procedure de sauvegarde } // Changer la couleur de fond
      //SaveHexGridToFile();
         SaveHexGridToCSV;
        end;
   // Changer la couleur du bouton en mode "hover"
   ColorToUse := ButtonSave.HoverColor;
   end
   else
       begin
       ColorToUse := ButtonSave.NormalColor;
       end;
     end;
procedure creationbouttons;
 begin
      ButtonSave := CreateButton(550, 500, ButtonWidth, ButtonHeight, DARKBLUE, SKYBLUE, RED);
   //ButtonRowsP := CreateButton(550, 10, 20, 20, DARKBLUE, SKYBLUE, RED);
    //ButtonRowsM := CreateButton(610, 10, 20, 20, DARKBLUE, SKYBLUE, RED);


 end;
begin
  // Initialisation de Raylib
  InitWindow(windowWidth, windowHeight, 'Hexagonal Grid - Flat Top');
  SetTargetFPS(60);

  // Génération de la grille d'hexagones
   GenerateHexagons;
   calculateNeighbors();
   CreationBouttons;
   //GuiEnable;
  // Boucle principale
  while not WindowShouldClose() do
  begin
    BeginDrawing();
    ClearBackground(RAYWHITE);
     HandleMouseClick();
    // Dessin des hexagones dans la grille
    //for i := 1 to TotalNbreHex do
    //begin
    //  DrawHexagon(HexGrid[i]);
    //end;

    DrawHexGrid(true);  // true dessine les nombres de heagones, false ne le fais pas
    DrawHexInfoBox();

    EndDrawing();
  end;

  // Fermeture de la fenêtre Raylib
  CloseWindow();
end.

