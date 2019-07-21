unit musicControl;

interface
uses CoolQSDK,windows,inifiles,classes;

const KEYEVENTF_EXTENDEDKEY = 1;
const KEYEVENTF_KEYUP = 2;

const VK_VOLUME_MUTE = $AD;
const VK_VOLUME_DOWN = $AE;
const VK_VOLUME_UP = $AF;
const VK_MEDIA_NEXT_TRACK = $B0;
const VK_MEDIA_PREV_TRACK = $B1;
const VK_MEDIA_STOP = $B2;
const VK_MEDIA_PLAY_PAUSE = $B3;

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
	i,j	:	longint;
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
			end
			else
			if (command='STOP') then begin
				musicControl_OPER(VK_MEDIA_STOP);
			end
			else
			if (command='VOL') and (s.count>=2) then begin
				command := upcase(s[1]);
				
				if (command='+') or (command='UP') or (command='ADD') or (command='INC') then begin
					if (s.count>=3) then begin
						j:=CharToNum(s[2]);
					end;
					if (j<=0) then j:=1;
					if (j>=100) then j:=100;
					for i:=1 to j do musicControl_OPER(VK_VOLUME_UP);
				end else
				if (command='-') or (command='DOWN') or (command='REDUCE') or (command='DEC') then begin
					if (s.count>=3) then begin
						j:=CharToNum(s[2]);
					end;
					if (j<=0) then j:=1;
					if (j>=100) then j:=100;
					for i:=1 to j do musicControl_OPER(VK_VOLUME_DOWN);
				end else
				if (command='0') or (command='MUTE') or (command='ZERO') then begin
					musicControl_OPER(VK_VOLUME_MUTE);
				end;

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