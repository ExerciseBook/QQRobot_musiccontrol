unit musicControl;

interface
uses CoolQSDK,windows,inifiles,classes;

const KEYEVENTF_EXTENDEDKEY = 1;
const KEYEVENTF_KEYUP = 2;
const VK_MEDIA_NEXT_TRACK = $B0;
const VK_MEDIA_PLAY_PAUSE = $B3;
const VK_MEDIA_PREV_TRACK = $B1;

procedure musicControl_Main(fromQQ:int64;msg:ansistring);
Function Config_Init:longint;

implementation
Var
	Config : Record
				MyOperator : int64;
			End;

procedure musicControl_OPER(OPER:longint);
Begin
	keybd_event(OPER,0,KEYEVENTF_EXTENDEDKEY,0);
End;

procedure musicControl_Main(fromQQ:int64;msg:ansistring);
Var
	S	:	TStringlist;
	command : ansistring;
Begin
	if fromQQ<>Config.MyOperator then exit();

	S					:= TStringlist.Create;
	S.StrictDelimiter	:= True;
	S.Delimiter			:= ' ';
	S.DelimitedText		:= msg;

	if (s.count>=1) then begin
		command := upcase(s[0]);
		if (length(command)>=3) and (command[1]+command[2]+command[3]=ansistring('！')) then command:='!'+copy(command,4,length(command));
		
		if (length(command)>0) and ((command[1]='/') or (command[1]='!')) then begin
		
			delete(command,1,1);
			if (command='NEXT') then begin
				musicControl_OPER(VK_MEDIA_NEXT_TRACK);
			end
			else
			if (command='PREV') then begin
				musicControl_OPER(VK_MEDIA_PREV_TRACK);
			end
			else
			if (command='PAUSE') then begin
				musicControl_OPER(VK_MEDIA_PLAY_PAUSE);
			end;
		end;
		
	end;

	S.Clear;
	S.Free;

End;

Function Config_Init:longint;
Var
	A:TIniFile;
Begin
	A:= TIniFile.Create(CQ_i_getAppDirectory+'config.ini',false);
	A.CacheUpdates:= true;
	
	Config.MyOperator:=A.ReadInt64('config','operator',0);
	if Config.MyOperator=0 then begin
		A.WriteInt64('config','operator',0);
	end;
		
	A.UpdateFile;
	A.Destroy;
	
	exit(0)
End;

end.