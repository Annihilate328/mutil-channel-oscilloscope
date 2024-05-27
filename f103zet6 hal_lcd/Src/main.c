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
uint16_t FIFO00[601],FIFO01[601];
/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{

  /* USER CODE BEGIN 1 */
	uint16_t i,mid,mid1;
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
		
		HAL_GPIO_WritePin(GPIOC,GPIO_PIN_6,GPIO_PIN_RESET);
		HAL_GPIO_WritePin(GPIOG,GPIO_PIN_8,GPIO_PIN_RESET);
		mid=FIFO00[1];
		for(i=0;i<601;i++){
			if(i>=3){
				POINT_COLOR =BLACK;
				LCD_DrawLine(i-2,mid*2,i-1,FIFO00[i]*2);
			}
			mid=FIFO00[i];
			HAL_GPIO_WritePin(GPIOB,GPIO_PIN_12,GPIO_PIN_SET);
			FIFO00[i]=HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_13)*128;
			FIFO00[i]=FIFO00[i]+HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_14)*64;
			FIFO00[i]=FIFO00[i]+HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_15)*32;
			FIFO00[i]=FIFO00[i]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_11)*16;
			HAL_GPIO_WritePin(GPIOB,GPIO_PIN_12,GPIO_PIN_RESET);
			FIFO00[i]=FIFO00[i]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_12)*8;
			FIFO00[i]=FIFO00[i]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_13)*4;
			FIFO00[i]=FIFO00[i]+HAL_GPIO_ReadPin(GPIOG, GPIO_PIN_2)*2;
			FIFO00[i]=FIFO00[i]+HAL_GPIO_ReadPin(GPIOG, GPIO_PIN_3)*1;
			if(FIFO00[i]==480 || FIFO00[i] == 0) FIFO00[i]=FIFO00[i-1];
			if(i>=3){
				POINT_COLOR =RED;
				LCD_DrawLine(i-2,FIFO00[i-1]*2,i-1,FIFO00[i]*2);
			}
		}

		HAL_GPIO_WritePin(GPIOC,GPIO_PIN_6,GPIO_PIN_RESET);
		HAL_GPIO_WritePin(GPIOG,GPIO_PIN_8,GPIO_PIN_SET);
		for(i=0;i<601;i++){
			if(i>=2){
				POINT_COLOR =BLACK;
				LCD_DrawLine(i-2,mid*2,i-1,FIFO01[i]*2);
			}
			mid=FIFO01[i];
			HAL_GPIO_WritePin(GPIOB,GPIO_PIN_12,GPIO_PIN_SET);
			FIFO01[i]=HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_13)*128;
			FIFO01[i]=FIFO01[i]+HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_14)*64;
			FIFO01[i]=FIFO01[i]+HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_15)*32;
			FIFO01[i]=FIFO01[i]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_11)*16;
			HAL_GPIO_WritePin(GPIOB,GPIO_PIN_12,GPIO_PIN_RESET);
			FIFO01[i]=FIFO01[i]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_12)*8;
			FIFO01[i]=FIFO01[i]+HAL_GPIO_ReadPin(GPIOD, GPIO_PIN_13)*4;
			FIFO01[i]=FIFO01[i]+HAL_GPIO_ReadPin(GPIOG, GPIO_PIN_2)*2;
			FIFO01[i]=FIFO01[i]+HAL_GPIO_ReadPin(GPIOG, GPIO_PIN_3)*1;
			if(i>=2){
				POINT_COLOR =GREEN;
				LCD_DrawLine(i-2,FIFO01[i-1]*2,i-1,FIFO01[i]*2);
			}
		}
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
