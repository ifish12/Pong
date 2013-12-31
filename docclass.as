package  {
	
	import flash.ui.Mouse;
    import flash.events.MouseEvent;  
	import flash.ui.Keyboard;
    import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
    import flash.text.TextFieldType;
	import flash.system.*;
	import flash.system.fscommand;
	import flashx.textLayout.accessibility.TextAccImpl;
	import flash.media.Sound;
	
	
	public class docclass extends MovieClip {
		 
		var RightPaddle:padel         = new padel(38, 40);
		var LeftPaddle:padel          = new padel(81, 65);
		var KeyboardPress:Array       = new Array(255);
		var myBalls:Array             = new Array();
		var P1ScoreT:TextField         = new TextField;
		var P2ScoreT:TextField         = new TextField;
		var playText:TextField        = new TextField;
		var stopText:TextField        = new TextField;
		var myFormat:TextFormat       = new TextFormat();

		var timerGameOver:int         = new int();
		
		var TopWall:Limits            = new Limits();
		var BotWall:Limits            = new Limits();
		
		var v:int                     = new int();
		var magicLeftNumber:Number    = new Number();
		var magicRightNumber:Number   = new Number();
		var theta:int                 = new int();
		var triX:Number               = new Number();
		var triY:Number               = new Number();
		
		var UpperLimit:int            = new int();
		var LowerLimit:int            = new int();
		
		var btnPlay:btnClass          = new btnClass();
		var btnStop:btnClass          = new btnClass();
		var playB:Boolean             = new Boolean();
		
		var P1Score:int               = new int();
		var P2Score:int               = new int();
		
		var boop:Sound                = new boopClass();

		public function docclass() {
			// constructor code
			v = 27;
			
			
			myFormat.size = 50;
			playText.text = "Play";
			stopText.text = "Exit";
			playText.textColor = 0xFF0000;
			stopText.textColor = 0xFF0000;
			P1ScoreT.textColor = 0xFF000;
			P2ScoreT.textColor = 0xFF000;
			stopText.setTextFormat(myFormat);
			playText.setTextFormat(myFormat);
			gameOverTxt.visible = false;
			
			playB = false;
			
			timerGameOver = 0;
			
			P1Score = 0;
			P2Score = 0;
			
			magicLeftNumber = 0.4;
			magicRightNumber = -0.4;
			LeftPaddle.x = 10;
			LeftPaddle.y = 450;
			
			RightPaddle.x = 1490;
			RightPaddle.y = 450;
			
			P1ScoreT.x = 1175;
			P1ScoreT.y = 163;
			
			P2ScoreT.x = 178;
			P2ScoreT.y = 163;
			
			TopWall.x = 750;
			TopWall.y = 10;
			
			BotWall.x = 750;
			BotWall.y = 900;
			
			btnPlay.x = 504;
			btnPlay.y = 278;
			
			playText.x = 550
			playText.y = 250;
			
			btnStop.x = 504;
			btnStop.y = 382;
			
			stopText.x = 550;
			stopText.y = 354;
			
			stage.addChild(btnPlay);
			stage.addChild(btnStop);
			stage.addChild(playText);
			stage.addChild(stopText);
			
			btnPlay.addEventListener(MouseEvent.CLICK, Play);
			btnStop.addEventListener(MouseEvent.CLICK, Stop);

		}
		private function processDOWN(e:KeyboardEvent):void {
			var k = e.keyCode;
			KeyboardPress[k] = true;
			RightPaddle.getArray(KeyboardPress);
			LeftPaddle.getArray(KeyboardPress);
			
			
			switch(k)
			{
				case Keyboard.B:
					var tempBall : pongball = new pongball(750, 450);
					myBalls.push(tempBall);
					stage.addChild(tempBall);
					break;
			}

		}
		private function processUP(e:KeyboardEvent):void {
			var k = e.keyCode;
			KeyboardPress[k] = false;
			RightPaddle.getArray(KeyboardPress);
			LeftPaddle.getArray(KeyboardPress);
		}
		private function HitTest(e:Event): void {
			
			for (var n in myBalls)
			{
				if ((RightPaddle.hitTestObject(myBalls[n])) || (myBalls[n].x >= RightPaddle.x))
				{
					if (RightPaddle.hitTestObject(myBalls[n]))
						{
							trace ("Ball hit the right paddle");
							theta = RightPaddle.y - myBalls[n].y;
							theta*=magicRightNumber;
							
							triX = Math.cos(theta)*v;
							triY = Math.sin(theta)*v;
							
							myBalls[n].moveCoord(triX, triY);
							boop.play();
						}
					
				}
				
				
				if ((LeftPaddle.hitTestObject(myBalls[n])) || (myBalls[n].x <= LeftPaddle.x))
				{
					if (LeftPaddle.hitTestObject(myBalls[n]))
						{
							trace ("Ball hit the left paddle");
							theta = LeftPaddle.y - myBalls[n].y;
							theta*=magicLeftNumber;
							
							triX = Math.cos(theta)*v;
							triY = Math.sin(theta)*v;
							
							myBalls[n].moveCoord(triX, triY);
							boop.play();
							
						}
	
				}
				
				if (BotWall.hitTestObject(myBalls[n]))
				{
					trace ("Ball hit bot wall");
					myBalls[n].Bouncer();
				}
				if (TopWall.hitTestObject(myBalls[n]))
				{
					trace ("Ball hit top wall");
					myBalls[n].Bouncer();
				}
			}
				for (var b in myBalls)
					if( myBalls[b].x < -2 || myBalls[b].x > 1502)
					{
						if (myBalls[b].x < -2)
						{
							trace ("Abote to remove and delete ball AND give P1 a point");
							P1Score++;
							P1ScoreT.text = P1Score.toString();
							P1ScoreT.setTextFormat(myFormat);
						}
						if (myBalls[b].x > 1502)
						{
							trace ("Abote to remove and delete ball AND give P2 a point");
							P2Score++;
							P2ScoreT.text = P2Score.toString();
							P2ScoreT.setTextFormat(myFormat);
						}
						stage.removeChild(myBalls[b]);	//remove the obstacle from the stage
						delete myBalls[b];	//remove the obstacle subscript

					}
				
				if (P2Score >= 15)
				{
					RightPaddle.gotoAndPlay("expl");
					RightPaddle.loser = true;
					stage.removeEventListener(KeyboardEvent.KEY_DOWN,processDOWN);
					stage.removeEventListener(KeyboardEvent.KEY_UP,processUP);
					for (var n in myBalls)
					{
						stage.removeChild(myBalls[b]);	//remove the obstacle from the stage
						delete myBalls[b];	//remove the obstacle subscript
					}
						
					if (timerGameOver == 104)
						GameOver();
					timerGameOver++;
				}
				if (P1Score >= 15)
				{
					LeftPaddle.gotoAndPlay("expl");
					LeftPaddle.loser = true;
					stage.removeEventListener(KeyboardEvent.KEY_DOWN,processDOWN);
					stage.removeEventListener(KeyboardEvent.KEY_UP,processUP);
					for (var n in myBalls)
					{
						stage.removeChild(myBalls[b]);	//remove the obstacle from the stage
						delete myBalls[b];	//remove the obstacle subscript
					}
					if (timerGameOver == 104)
					{
						GameOver();
					}
					timerGameOver++;
				}
		}
		private function Play(e:MouseEvent):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN,processDOWN);
			stage.addEventListener(KeyboardEvent.KEY_UP,processUP);
			stage.addEventListener(Event.ENTER_FRAME,HitTest);
			stage.addChild(RightPaddle);
			stage.addChild(LeftPaddle);
			stage.addChild(TopWall);
			stage.addChild(BotWall);
			stage.addChild(P1ScoreT);
			stage.addChild(P2ScoreT);
			playText.visible = false;
			btnPlay.visible = false;
			btnStop.visible = false;
			stopText.visible = false;
			InstructionsBox.visible = false;
			playB = true;
			P2Score = 0;
			P1Score = 0;
			P2ScoreT.text = P1Score.toString();
			P1ScoreT.text = P2Score.toString();
			RightPaddle.gotoAndPlay(1);
			LeftPaddle.gotoAndPlay(1);
			P2ScoreT.setTextFormat(myFormat);
			P1ScoreT.setTextFormat(myFormat);
			gameOverTxt.visible = false;
	
			
			
			
		}
		private function Stop(e:MouseEvent):void {
			fscommand("quit");
		}
		private function GameOver(): void {
			stage.removeChild(RightPaddle);
			stage.removeChild(LeftPaddle);
			stage.removeChild(TopWall);
			stage.removeChild(BotWall);
			stage.removeEventListener(Event.ENTER_FRAME,HitTest);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,processDOWN);
			stage.removeEventListener(KeyboardEvent.KEY_UP,processUP);
			RightPaddle.loser = false;
			LeftPaddle.loser = false;
			playText.text = "Play again?"
			playText.visible = true;
			gameOverTxt.visible = true;
			btnPlay.visible = true;
			playText.textColor = 0xFF0000;
			P1ScoreT.textColor = 0xFF000;
			P2ScoreT.textColor = 0xFF000;
			playText.setTextFormat(myFormat);
		}
	}
	
}
