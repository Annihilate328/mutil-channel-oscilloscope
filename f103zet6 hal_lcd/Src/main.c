/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2023 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */
#include "lcd.h"
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "gpio.h"
#include "fsmc.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/

/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
uint16_t FIFO00[601],FIFO01[601],Y=0,X=0;
/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{

  /* USER CODE BEGIN 1 */
	uint16_t i,mid,vmid,y0=0,y1=0,j;
	float V0MAX,V0MIN,V1MAX,V1MIN;
  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_FSMC_Init();
  /* USER CODE BEGIN 2 */
	LCD_Init();
	LCD_Display_Dir(1);
	HAL_GPIO_WritePin(LCD_BL_GPIO_Port, LCD_BL_Pin,GPIO_PIN_SET);
	LCD_Fill(0,0,600,480,0x0000);
	POINT_COLOR =WHITE;
	LCD_DrawLine(0,240,600,240);
	LCD_DrawLine(300,0,300,480);
	POINT_COLOR =GRAY;
	LCD_DrawLine(0,420,600,420);
	LCD_DrawLine(0,360,600,360);
	LCD_DrawLine(0,300,600,300);
	LCD_DrawLine(0,180,600,180);
	LCD_DrawLine(0,120,600,120);
	LCD_DrawLine(0,60,600,60);
	
	LCD_DrawLine(540,0,540,480);
	LCD_DrawLine(480,0,480,480);
	LCD_DrawLine(420,0,420,480);
	LCD_DrawLine(360,0,360,480);
	LCD_DrawLine(240,0,240,480);
	LCD_DrawLine(180,0,180,480);
	LCD_DrawLine(120,0,120,480);
	LCD_DrawLine(60,0,60,480);
//	POINT_COLOR =RED;
//	LCD_ShowString(620,0,240,24,24,"Frequency:");
//	LCD_ShowString(620,30,240,24,24,"499.85KHz");
//	LCD_ShowString(620,60,240,24,24,"V+max:");
//	LCD_ShowString(620,90,240,24,24,"+495mV");
//	LCD_ShowString(620,120,240,24,24,"V-max:");
//	LCD_ShowString(620,150,240,24,24,"-496mV");
  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
		y1=Y;
		POINT_COLOR =WHITE;
		LCD_DrawLine(0,240,600,240);
		LCD_DrawLine(300,0,300,480);
		HAL_GPIO_WritePin(GPIOG,GPIO_PIN_6,GPIO_PIN_SET);
		HAL_GPIO_WritePin(GPIOG,GPIO_PIN_7,GPIO_PIN_SET);
		POINT_COLOR =GRAY;
		LCD_DrawLine(0,420,600,420);
		LCD_DrawLine(0,360,600,360);
		LCD_DrawLine(0,300,600,300);
		LCD_DrawLine(0,180,600,180);
		LCD_DrawLine(0,120,600,120);
		LCD_DrawLine(0,60,600,60);
	
		LCD_DrawLine(540,0,540,480);
		LCD_DrawLine(480,0,480,480);
		LCD_DrawLine(420,0,420,480);
		LCD_DrawLine(360,0,360,480);
		LCD_DrawLine(240,0,240,480);
		LCD_DrawLine(180,0,180,480);
		LCD_DrawLine(120,0,120,480);
		LCD_DrawLine(60,0,60,480);
		if(Y==0) LCD_ShowString(620,420,240,24,24,"   1V");
		else if(Y==1) LCD_ShowString(620,420,240,24,24,"500mV");
		if(X==0) LCD_ShowString(620,450,240,24,24,"1.6nS");
		else if(X==1) LCD_ShowString(620,450,240,24,24,"0.8nS");
		HAL_GPIO_WritePin(GPIOC,GPIO_PIN_6,GPIO_PIN_RESET);
		HAL_GPIO_WritePin(GPIOG,GPIO_PIN_8,GPIO_PIN_SET);
		V1MAX=0;
		V1MIN=255;
		j=0;
		for(i=0;i<1202;i++){
			POINT_COLOR =BLACK;
			if(j>=3){
				if(y0==0) LCD_DrawLine(j-2,240+(mid-127)*1.88,j-1,240+(FIFO01[j]-127)*1.88);
				if(y0==1) LCD_DrawLine(j-2,240+(mid-127)*3.76,j-1,240+(FIFO01[j]-127)*3.76);
			}
			if(X==1){
				mid=FIFO01[j];
				HAL_GPIO_WritePin(GPIOB,GPIO_PIN_12,GPIO_PIN_SET);
				FIFO01[j]=HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_13)*128;
				FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_14)*64;
				FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_15)*32;
				FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_11)*16;
				HAL_GPIO_WritePin(GPIOB,GPIO_PIN_12,GPIO_PIN_RESET);
				FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_12)*8;
				FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_13)*4;
				FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOG, GPIO_PIN_2)*2;
				FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOG, GPIO_PIN_3)*1;
			}
			if(X==0)mid=FIFO01[j];
			HAL_GPIO_WritePin(GPIOB,GPIO_PIN_12,GPIO_PIN_SET);
			FIFO01[j]=HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_13)*128;
			FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_14)*64;
			FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_15)*32;
			FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_11)*16;
			HAL_GPIO_WritePin(GPIOB,GPIO_PIN_12,GPIO_PIN_RESET);
			FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_12)*8;
			FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_13)*4;
			FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOG, GPIO_PIN_2)*2;
			FIFO01[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOG, GPIO_PIN_3)*1;
			if(j==601) break;
			if(FIFO01[j]>V1MAX) V1MAX=FIFO01[j];
			if(FIFO01[j]<V1MIN) V1MIN=FIFO01[j];
			POINT_COLOR =GREEN;
			if(j>=3){
				if(y1==0) LCD_DrawLine(j-2,240+(FIFO01[j-1]-127)*1.88,j-1,240+(FIFO01[j]-127)*1.88);
				if(y1==1) LCD_DrawLine(j-2,240+(FIFO01[j-1]-127)*3.76,j-1,240+(FIFO01[j]-127)*3.76);
			}
			j++;
			if(j==601) break;
		}
		POINT_COLOR =GREEN;
		V1MAX=(V1MAX-127)/1700;
		V1MIN=(V1MIN-127)/1700;
		LCD_ShowString(620,240,240,24,24,"V+max:");
		if(V1MAX<0) LCD_ShowString(620,270,240,24,24,"-");
		for(i=0;i<6;i++){
			if(i==2) LCD_ShowString(665,270,240,24,24,".");
			else {
				V1MAX*=10;
				vmid=V1MAX;
				LCD_ShowxNum(635+i*15,270,vmid,1,24,0);
			}
		}
		LCD_ShowString(620,300,240,24,24,"V-max:");
		if(V1MIN<0) LCD_ShowString(620,330,240,24,24,"-");
		for(i=0;i<6;i++){
			if(i==2) LCD_ShowString(665,330,240,24,24,".");
			else {
				V1MIN*=10;
				vmid=V1MIN;
				LCD_ShowxNum(635+i*15,330,vmid,1,24,0);
			}
		}
		
		
		HAL_GPIO_WritePin(GPIOC,GPIO_PIN_6,GPIO_PIN_RESET);
		HAL_GPIO_WritePin(GPIOG,GPIO_PIN_8,GPIO_PIN_RESET);
		mid=FIFO00[1];
		V0MAX=0;
		V0MIN=255;
		j=0;
		for(i=0;i<1202;i++){
			POINT_COLOR =BLACK;
			if(j>=3){
				if(y0==0) LCD_DrawLine(j-2,240+(mid-127)*1.88,j-1,240+(FIFO00[j]-127)*1.88);
				if(y0==1) LCD_DrawLine(j-2,240+(mid-127)*3.76,j-1,240+(FIFO00[j]-127)*3.76);
			}
			if(X==1){
				mid=FIFO00[j];
				HAL_GPIO_WritePin(GPIOB,GPIO_PIN_12,GPIO_PIN_SET);
				FIFO00[j]=HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_13)*128;
				FIFO00[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_14)*64;
				FIFO00[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_15)*32;
				FIFO00[j]=FIFO01[j]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_11)*16;
				HAL_GPIO_WritePin(GPIOB,GPIO_PIN_12,GPIO_PIN_RESET);
				FIFO00[j]=FIFO00[j]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_12)*8;
				FIFO00[j]=FIFO00[j]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_13)*4;
				FIFO00[j]=FIFO00[j]+HAL_GPIO_ReadPin(GPIOG, GPIO_PIN_2)*2;
				FIFO00[j]=FIFO00[j]+HAL_GPIO_ReadPin(GPIOG, GPIO_PIN_3)*1;
			}
			if(X==0)mid=FIFO00[j];
			HAL_GPIO_WritePin(GPIOB,GPIO_PIN_12,GPIO_PIN_SET);
			FIFO00[j]=HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_13)*128;
			FIFO00[j]=FIFO00[j]+HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_14)*64;
			FIFO00[j]=FIFO00[j]+HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_15)*32;
			FIFO00[j]=FIFO00[j]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_11)*16;
			HAL_GPIO_WritePin(GPIOB,GPIO_PIN_12,GPIO_PIN_RESET);
			FIFO00[j]=FIFO00[j]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_12)*8;
			FIFO00[j]=FIFO00[j]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_13)*4;
			FIFO00[j]=FIFO00[j]+HAL_GPIO_ReadPin(GPIOG, GPIO_PIN_2)*2;
			FIFO00[j]=FIFO00[j]+HAL_GPIO_ReadPin(GPIOG, GPIO_PIN_3)*1;
			if(FIFO00[j]>V0MAX) V0MAX=FIFO00[j];
			if(FIFO00[j]<V0MIN) V0MIN=FIFO00[j];
			POINT_COLOR =RED;
			if(j>=3){
				if(y1==0) LCD_DrawLine(j-2,240+(FIFO00[j-1]-127)*1.88,j-1,240+(FIFO00[j]-127)*1.88);
				if(y1==1) LCD_DrawLine(j-2,240+(FIFO00[j-1]-127)*3.76,j-1,240+(FIFO00[j]-127)*3.76);
			}
			j++;
			if(j==601) break;
		}
		POINT_COLOR =RED;
		V0MAX=(V0MAX-127)/1700;
		V0MIN=(V0MIN-127)/1700;
		LCD_ShowString(620,60,240,24,24,"V+max:");
		if(V0MAX<0) LCD_ShowString(620,90,240,24,24,"-");
		for(i=0;i<6;i++){
			if(i==2) LCD_ShowString(665,90,240,24,24,".");
			else {
				V0MAX*=10;
				vmid=V0MAX;
				LCD_ShowxNum(635+i*15,90,vmid,1,24,0);
			}
		}
		LCD_ShowString(620,120,240,24,24,"V-max:");
		if(V0MIN<0) LCD_ShowString(620,150,240,24,24,"-");
		for(i=0;i<6;i++){
			if(i==2) LCD_ShowString(665,150,240,24,24,".");
			else {
				V0MIN*=10;
				vmid=V0MIN;
				LCD_ShowxNum(635+i*15,150,vmid,1,24,0);
			}
		}
		y0=y1;
		HAL_GPIO_WritePin(GPIOG,GPIO_PIN_6,GPIO_PIN_RESET);
		HAL_GPIO_WritePin(GPIOG,GPIO_PIN_7,GPIO_PIN_RESET);
	}
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.HSEPredivValue = RCC_HSE_PREDIV_DIV1;
  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLMUL = RCC_PLL_MUL9;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
  {
    Error_Handler();
  }

  /** Enables the Clock Security System
  */
  HAL_RCC_EnableCSS();
}

/* USER CODE BEGIN 4 */
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
	if(GPIO_Pin == GPIO_PIN_4)
	{
		HAL_Delay(5);	//????
    HAL_Delay(5);	//????
		Y++;
		if(Y==2) Y=0;
	}	if(GPIO_Pin == GPIO_PIN_3)
	{
		HAL_Delay(5);	//????
    HAL_Delay(5);	//????
		X++;
		if(X==2) X=0;
	}
}
/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
