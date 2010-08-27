//
//  Mazes.m
//  iEngine
//
//  Created by CS 526 on 3/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Farm.h"

@implementation VectorPoints
@end

@implementation Farm
+(void)InitPhysics:(level)levelNo physicsSpace:(cpSpace*)space
{
	cpInitChipmunk();	
	
	cpBody *staticBody = cpBodyNew(INFINITY, INFINITY);

	cpSpaceResizeStaticHash(space, 400.0f, 40);
	cpSpaceResizeActiveHash(space, 100, 600);
	
	space->gravity = ccp(0, 0);
	space->elasticIterations = space->iterations;
	
	cpShape *shape;
	Farm *farm = [[[Farm alloc] init:levelNo] autorelease];
	
	for(int i=0;i<[farm->polygonArray count];i++)
	{ 
		VectorPoints* vP = ((VectorPoints*)[farm->polygonArray objectAtIndex:i]);
		
		if( vP->noOfPoints > 2)
		{	// Polygon
			shape = cpPolyShapeNew(staticBody,vP->noOfPoints,vP->points, cpvzero);
			shape->e=0;
			shape->u=1;
			cpSpaceAddShape(space,shape);
		}
		else if( vP->noOfPoints == 2 && vP->edgetype == kBound)
		{	//Bound
			shape =cpSegmentShapeNew(staticBody,vP->points[0] , vP->points[1], 0.0f);
			shape->e=0;
			shape->u=1;
			cpSpaceAddShape(space,shape);
		}
		else if(vP->noOfPoints == 2 && vP->edgetype == kCheckPoint)
		{	//CheckPoint
			shape =cpSegmentShapeNew(staticBody, vP->points[0], vP->points[1], 0.0f);
			shape->e = 1;
			shape->u = 0.8f;
			shape->data=vP->checkPointNo;
			shape->collision_type=2;
			cpSpaceAddStaticShape(space, shape);
		}
		else if(vP->noOfPoints == 2 && vP->edgetype == kExit)
		{	//Exit
			shape =cpSegmentShapeNew(staticBody, vP->points[0], vP->points[1], 0.0f);
			shape->e = 0;
			shape->u = 0;
//			shape->data =(NSInteger*)1;
			shape->collision_type=3;
			cpSpaceAddStaticShape(space, shape);
		}
		else if(vP->noOfPoints == 2 && vP->edgetype == kNoExit)
		{	//NoExit
			shape =cpSegmentShapeNew(staticBody, vP->points[0], vP->points[1], 0.0f);
			shape->e = 0;
			shape->u =0;
//			shape->data =(NSInteger*)3;
			shape->collision_type=4;
			cpSpaceAddStaticShape(space,shape);
		}
	}
	

}
- (id)init:(level)levelNo
{
	
	polygonArray = [NSMutableArray array];
	VectorPoints* vectorArray;
	if(levelNo==ONE)
	{
		//left
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(48,462);
		vectorArray->points[1]=cpv(320,464);
		vectorArray->edgetype = kBound;
		vectorArray->noOfPoints=2;
		
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//bottom
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(17,407);
		vectorArray->points[1]=cpv(8,71);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kBound;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//right
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(52,12);
		vectorArray->points[1]=cpv(320,16);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kBound;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//exit
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(332,0);
		vectorArray->points[1]=cpv(332,480);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kExit;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//noExit
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(320,0);
		vectorArray->points[1]=cpv(320,480);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kNoExit;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//1
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(21,397);
		vectorArray->points[1]=cpv(29,446);
		vectorArray->points[2]=cpv(48,458);
		vectorArray->points[3]=cpv(49,418);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//2
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(150,401);
		vectorArray->points[1]=cpv(147,437);
		vectorArray->points[2]=cpv(184,440);
		vectorArray->points[3]=cpv(182,408);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//3
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(206,416);
		vectorArray->points[1]=cpv(207,442);
		vectorArray->points[2]=cpv(218,449);
		vectorArray->points[3]=cpv(234,447);
		vectorArray->points[4]=cpv(236,426);
		vectorArray->points[5]=cpv(219,407);
		
		vectorArray->noOfPoints=6;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//4
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(316,402);
		vectorArray->points[1]=cpv(278,441);
		vectorArray->points[2]=cpv(285,460);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//5
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(220,389);
		vectorArray->points[1]=cpv(269,412);
		vectorArray->points[2]=cpv(285,412);
		vectorArray->points[3]=cpv(299,382);
		vectorArray->points[4]=cpv(285,367);
		vectorArray->points[5]=cpv(240,346);
		vectorArray->points[6]=cpv(220,358);
		
		vectorArray->noOfPoints=7;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//6
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(257,309);
		vectorArray->points[1]=cpv(315,311);
		vectorArray->points[2]=cpv(316,284);
		vectorArray->points[3]=cpv(274,277);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		/////////////
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(269,307);
		vectorArray->points[1]=cpv(288,329);
		vectorArray->points[2]=cpv(317,331);
		vectorArray->points[3]=cpv(316,283);
		vectorArray->points[4]=cpv(297,271);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//7
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(44,311);
		vectorArray->points[1]=cpv(60,351);
		vectorArray->points[2]=cpv(70,355);
		vectorArray->points[3]=cpv(109,351);
		vectorArray->points[4]=cpv(72,314);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//8
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(144,326);
		vectorArray->points[1]=cpv(155,376);
		vectorArray->points[2]=cpv(185,374);
		vectorArray->points[3]=cpv(197,334);
		vectorArray->points[4]=cpv(169,311);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//9
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(58,238);
		vectorArray->points[1]=cpv(60,270);
		vectorArray->points[2]=cpv(79,292);
		vectorArray->points[3]=cpv(98,273);
		vectorArray->points[4]=cpv(99,246);
		vectorArray->points[5]=cpv(76,225);
		
		vectorArray->noOfPoints=6;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//10
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(101,244);
		vectorArray->points[1]=cpv(107,247);
		vectorArray->points[2]=cpv(112,239);
		vectorArray->points[3]=cpv(90,202);
		vectorArray->points[4]=cpv(72,221);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//11
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(149,213);
		vectorArray->points[1]=cpv(189,250);
		vectorArray->points[2]=cpv(212,234);
		vectorArray->points[3]=cpv(163,191);
		vectorArray->points[4]=cpv(145,193);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//12
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(188,253);
		vectorArray->points[1]=cpv(191,298);
		vectorArray->points[2]=cpv(234,295);
		vectorArray->points[3]=cpv(233,247);
		vectorArray->points[4]=cpv(215,235);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//13
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(293,244);
		vectorArray->points[1]=cpv(318,242);
		vectorArray->points[2]=cpv(319,213);
		vectorArray->points[3]=cpv(294,216);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//14
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(16,203);
		vectorArray->points[1]=cpv(29,202);
		vectorArray->points[2]=cpv(28,186);
		vectorArray->points[3]=cpv(16,185);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//15
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(37,142);
		vectorArray->points[1]=cpv(41,169);
		vectorArray->points[2]=cpv(57,175);
		vectorArray->points[3]=cpv(110,148);
		vectorArray->points[4]=cpv(119,127);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//16
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(142,135);
		vectorArray->points[1]=cpv(153,153);
		vectorArray->points[2]=cpv(173,145);
		vectorArray->points[3]=cpv(164,121);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//17
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(196,166);
		vectorArray->points[1]=cpv(219,162);
		vectorArray->points[2]=cpv(236,132);
		vectorArray->points[3]=cpv(219,103);
		vectorArray->points[4]=cpv(199,115);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//18
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(237,174);
		vectorArray->points[1]=cpv(243,195);
		vectorArray->points[2]=cpv(258,201);
		vectorArray->points[3]=cpv(279,192);
		vectorArray->points[4]=cpv(278,175);
		vectorArray->points[5]=cpv(261,160);
		
		vectorArray->noOfPoints=6;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//19
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(287,121);
		vectorArray->points[1]=cpv(312,188);
		vectorArray->points[2]=cpv(319,175);
		vectorArray->points[3]=cpv(318,128);
		vectorArray->points[4]=cpv(292,113);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//20
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(11,80);
		vectorArray->points[1]=cpv(32,74);
		vectorArray->points[2]=cpv(59,17);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//21
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(65,51);
		vectorArray->points[1]=cpv(74,77);
		vectorArray->points[2]=cpv(93,72);
		vectorArray->points[3]=cpv(101,46);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//22
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(92,73);
		vectorArray->points[1]=cpv(105,93);
		vectorArray->points[2]=cpv(124,70);
		vectorArray->points[3]=cpv(103,48);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//23
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(152,43);
		vectorArray->points[1]=cpv(150,60);
		vectorArray->points[2]=cpv(160,90);
		vectorArray->points[3]=cpv(183,95);
		vectorArray->points[4]=cpv(196,61);
		vectorArray->points[5]=cpv(163,33);
		
		vectorArray->noOfPoints=6;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//24
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(234,70);
		vectorArray->points[1]=cpv(253,92);
		vectorArray->points[2]=cpv(264,82);
		vectorArray->points[3]=cpv(243,65);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//25
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(231,16);
		vectorArray->points[1]=cpv(233,21);
		vectorArray->points[2]=cpv(237,26);
		vectorArray->points[3]=cpv(248,30);
		vectorArray->points[4]=cpv(254,18);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//26
	    vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(289,18);
		vectorArray->points[1]=cpv(279,41);
		vectorArray->points[2]=cpv(282,57);
		vectorArray->points[3]=cpv(298,59);
		vectorArray->points[4]=cpv(317,42);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//27
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(64,411);
		vectorArray->points[1]=cpv(57,455);
		vectorArray->points[2]=cpv(130,459);
		vectorArray->points[3]=cpv(132,434);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//28
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(83,412);
		vectorArray->points[1]=cpv(128,430);
		vectorArray->points[2]=cpv(122,395);
		vectorArray->points[3]=cpv(116,390);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
	}
	
	else if(levelNo==TWO)
    {
		//left
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]= cpv(0,466);
		vectorArray->points[1]=cpv(320,480);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kBound;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//bottom
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(9,407);
		vectorArray->points[1]=cpv(9,71);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kBound;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//right
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(52,10);
		vectorArray->points[1]=cpv(320,0);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kBound;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//checkpoint1
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(109,407);
		vectorArray->points[1]=cpv(129,447);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kCheckPoint;
		vectorArray->checkPointNo = (int*)1;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//checkpoint2
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(30,167);
		vectorArray->points[1]=cpv(11,148);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kCheckPoint;
		vectorArray->checkPointNo = (int*)2;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//checkpoint3
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(224,43);
		vectorArray->points[1]=cpv(243,7);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kCheckPoint;
		vectorArray->checkPointNo = (int*)3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//checkpoint4
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(219,291);
		vectorArray->points[1]=cpv(208,268);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kCheckPoint;
		vectorArray->checkPointNo = (int*)4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//exit
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(332,0);
		vectorArray->points[1]=cpv(332,480);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kExit;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//noExit
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(320,0);
		vectorArray->points[1]=cpv(320,480);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kNoExit;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//1
		VectorPoints* vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(10,396);
		vectorArray->points[1]=cpv(46,459);
		vectorArray->points[2]=cpv(41,398);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//2
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(62,359);
		vectorArray->points[1]=cpv(51,422);
		vectorArray->points[2]=cpv(79,428);
		vectorArray->points[3]=cpv(101,405);
		vectorArray->points[4]=cpv(90,373);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//3
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(125,460);
		vectorArray->points[1]=cpv(183,460);
		vectorArray->points[2]=cpv(137,437);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//4
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(160,380);
		vectorArray->points[1]=cpv(138,435);
		vectorArray->points[2]=cpv(152,443);
		vectorArray->points[3]=cpv(177,390);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//5
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(138,371);
		vectorArray->points[1]=cpv(143,410);
		vectorArray->points[2]=cpv(157,369);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//6
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(214,460);
		vectorArray->points[1]=cpv(289,467);
		vectorArray->points[2]=cpv(222,431);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//7
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(225,416);
		vectorArray->points[1]=cpv(254,444);
		vectorArray->points[2]=cpv(274,431);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//8
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(282,383);
		vectorArray->points[1]=cpv(316,409);
		vectorArray->points[2]=cpv(315,335);
		vectorArray->points[3]=cpv(292,338);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//9
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(212,389);
		vectorArray->points[1]=cpv(249,391);
		vectorArray->points[2]=cpv(254,347);
		vectorArray->points[3]=cpv(230,355);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//10
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(109,347);
		vectorArray->points[1]=cpv(122,331);
		vectorArray->points[2]=cpv(88,283);
		vectorArray->points[3]=cpv(93,334);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//11
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(159,333);
		vectorArray->points[1]=cpv(181,333);
		vectorArray->points[2]=cpv(175,314);
		vectorArray->points[3]=cpv(162,309);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//12
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(40,330);
		vectorArray->points[1]=cpv(60,307);
		vectorArray->points[2]=cpv(47,285);
		vectorArray->points[3]=cpv(23,312);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//13
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(233,286);
		vectorArray->points[1]=cpv(259,258);
		vectorArray->points[2]=cpv(248,220);
		vectorArray->points[3]=cpv(206,258);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//14
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(151,262);
		vectorArray->points[1]=cpv(166,265);
		vectorArray->points[2]=cpv(190,183);
		vectorArray->points[3]=cpv(137,204);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//15
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(81,242);
		vectorArray->points[1]=cpv(105,250);
		vectorArray->points[2]=cpv(108,215);
		vectorArray->points[3]=cpv(84,223);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//16
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(13,227);
		vectorArray->points[1]=cpv(43,238);
		vectorArray->points[2]=cpv(54,192);
		vectorArray->points[3]=cpv(35,161);
		vectorArray->points[4]=cpv(12,180);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//17
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(85,182);
		vectorArray->points[1]=cpv(147,182);
		vectorArray->points[2]=cpv(161,130);
		vectorArray->points[3]=cpv(116,103);
		vectorArray->points[4]=cpv(75,143);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//18
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(279,219);
		vectorArray->points[1]=cpv(316,234);
		vectorArray->points[2]=cpv(316,135);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//19
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(221,163);
		vectorArray->points[1]=cpv(242,185);
		vectorArray->points[2]=cpv(250,173);
		vectorArray->points[3]=cpv(239,146);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//20
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(269,133);
		vectorArray->points[1]=cpv(281,125);
		vectorArray->points[2]=cpv(288,83);
		vectorArray->points[3]=cpv(252,64);
		vectorArray->points[4]=cpv(251,93);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//21
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(14,94);
		vectorArray->points[1]=cpv(41,89);
		vectorArray->points[2]=cpv(53,11);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//22
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(84,71);
		vectorArray->points[1]=cpv(125,69);
		vectorArray->points[2]=cpv(157,48);
		vectorArray->points[3]=cpv(95,27);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//23
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(194,59);
		vectorArray->points[1]=cpv(178,89);
		vectorArray->points[2]=cpv(209,102);
		vectorArray->points[3]=cpv(217,67);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//24
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(183,5);
		vectorArray->points[1]=cpv(195,56);
		vectorArray->points[2]=cpv(217,60);
		vectorArray->points[3]=cpv(225,7);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		
		//25
	    vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(250,301);
		vectorArray->points[1]=cpv(262,314);
		vectorArray->points[2]=cpv(287,307);
		vectorArray->points[3]=cpv(278,271);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
	}	
	
	else if(levelNo==THREE)
	{
		//left
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]= cpv(59,462);
		vectorArray->points[1]=cpv(316,470);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kBound;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//bottom
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(5,386);
		vectorArray->points[1]=cpv(7,101);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kBound;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//right
		//not there
		
		//checkpoint1
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(238,467);
		vectorArray->points[1]=cpv(218,451);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kCheckPoint;
		vectorArray->checkPointNo = (int*)1;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//checkpoint2
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(38,434);
		vectorArray->points[1]=cpv(61,459);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kCheckPoint;
		vectorArray->checkPointNo = (int*)2;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//checkpoint3
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(22,234);
		vectorArray->points[1]=cpv(7,225);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kCheckPoint;
		vectorArray->checkPointNo = (int*)3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//checkpoint4
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(95,232);
		vectorArray->points[1]=cpv(110,207);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kCheckPoint;
		vectorArray->checkPointNo = (int*)4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//exit
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(332,0);
		vectorArray->points[1]=cpv(332,480);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kExit;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//noExit
		vectorArray = [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(320,0);
		vectorArray->points[1]=cpv(320,480);
		
		vectorArray->noOfPoints=2;
		vectorArray->edgetype = kNoExit;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//1
		VectorPoints* vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(6,390);
		vectorArray->points[1]=cpv(40,458);
		vectorArray->points[2]=cpv(32,393);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//2
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(87,387);
		vectorArray->points[1]=cpv(123,430);
		vectorArray->points[2]=cpv(181,413);
		vectorArray->points[3]=cpv(182,368);
		vectorArray->points[4]=cpv(151,353);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//3
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(201,459);
		vectorArray->points[1]=cpv(226,460);
		vectorArray->points[2]=cpv(215,444);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//4
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(262,438);
		vectorArray->points[1]=cpv(297,438);
		vectorArray->points[2]=cpv(295,408);
		vectorArray->points[3]=cpv(262,425);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//5
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(240,386);
		vectorArray->points[1]=cpv(316,365);
		vectorArray->points[2]=cpv(314,299);
		vectorArray->points[3]=cpv(271,301);
		vectorArray->points[4]=cpv(222,335);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//6
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(30,354);
		vectorArray->points[1]=cpv(87,345);
		vectorArray->points[2]=cpv(104,324);
		vectorArray->points[3]=cpv(36,322);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//7
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(114,286);
		vectorArray->points[1]=cpv(179,270);
		vectorArray->points[2]=cpv(186,219);
		vectorArray->points[3]=cpv(112,218);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//8
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(20,293);
		vectorArray->points[1]=cpv(62,254);
		vectorArray->points[2]=cpv(34,231);
		vectorArray->points[3]=cpv(11,258);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//9
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(174,195);
		vectorArray->points[1]=cpv(214,149);
		vectorArray->points[2]=cpv(138,131);
		vectorArray->points[3]=cpv(145,183);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//10
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(229,253);
		vectorArray->points[1]=cpv(282,255);
		vectorArray->points[2]=cpv(318,235);
		vectorArray->points[3]=cpv(316,211);
		vectorArray->points[4]=cpv(229,213);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//11
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(44,179);
		vectorArray->points[1]=cpv(103,189);
		vectorArray->points[2]=cpv(93,153);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//12
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(247,172);
		vectorArray->points[1]=cpv(283,170);
		vectorArray->points[2]=cpv(290,127);
		vectorArray->points[3]=cpv(273,105);
		vectorArray->points[4]=cpv(249,121);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//13
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(158,90);
		vectorArray->points[1]=cpv(178,104);
		vectorArray->points[2]=cpv(225,100);
		vectorArray->points[3]=cpv(216,77);
		vectorArray->points[4]=cpv(159,72);
		
		vectorArray->noOfPoints=5;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//14
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(233,6);
		vectorArray->points[1]=cpv(250,46);
		vectorArray->points[2]=cpv(318,61);
		vectorArray->points[3]=cpv(317,3);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//15
		vectorArray= [[VectorPoints alloc] init];
		
		vectorArray->noOfPoints=0;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//16
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(105,52);
		vectorArray->points[1]=cpv(225,23);
		vectorArray->points[2]=cpv(226,1);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//17
		vectorArray= [[VectorPoints alloc] init];
		
		vectorArray->noOfPoints=0;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//18
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(7,101);
		vectorArray->points[1]=cpv(25,100);
		
		vectorArray->noOfPoints=2;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//19
        vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(58,20);
		vectorArray->points[1]=cpv(73,85);
		vectorArray->points[2]=cpv(140,62);
		vectorArray->points[3]=cpv(133,20);
		
		vectorArray->noOfPoints=4;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//20
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(92,82);
		vectorArray->points[1]=cpv(136,108);
		vectorArray->points[2]=cpv(133,70);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		
		//21
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(7,101);
		vectorArray->points[1]=cpv(26,101);
		vectorArray->points[2]=cpv(26,0);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		//22
		vectorArray= [[VectorPoints alloc] init];
		vectorArray->points[0]=cpv(26,48);
		vectorArray->points[1]=cpv(65,48);
		vectorArray->points[2]=cpv(67,4);
		
		vectorArray->noOfPoints=3;
		[polygonArray addObject:vectorArray];
		[vectorArray release];
		
		RandomPoints[0]=cpv(190,48);
		RandomPoints[1]=cpv(202,125);
		RandomPoints[2]=cpv(168,158);
		RandomPoints[3]=cpv(93,115);
		RandomPoints[4]=cpv(67,371);
		RandomPoints[5]=cpv(3,157);
		RandomPoints[6]=cpv(83,219);
		RandomPoints[7]=cpv(209,260);
		RandomPoints[8]=cpv(227,438);
		RandomPoints[9]=cpv(51,416);
		RandomPoints[10]=cpv(17,359);
		RandomPoints[11]=cpv(76,338);
		RandomPoints[12]=cpv(125,314);
		RandomPoints[13]=cpv(216,352);
		RandomPoints[14]=cpv(150,367);
		RandomPoints[15]=cpv(13,101);
		RandomPoints[16]=cpv(105,125);
		RandomPoints[17]=cpv(268,214);
		RandomPoints[18]=cpv(263,280);
		RandomPoints[19]=cpv(27,29);

	}
	
	return self;
}



@end
